import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/app_config.dart';
import '../../core/config/theme.dart';

class BookAppointmentPage extends StatefulWidget {
  final String userId;
  final String token;

  const BookAppointmentPage({super.key, required this.userId, required this.token});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  List doctors = [];
  String? selectedDoctorId;
  DateTime? selectedDate;
  String? selectedTime;
  TextEditingController reasonController = TextEditingController();
  List<String> availableTimes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final url = Uri.parse(AppointmentsDoctors);
      final res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      });

      if (res.statusCode == 200) {
        setState(() {
          doctors = json.decode(utf8.decode(res.bodyBytes));
        });
      } else {
        print("⚠️ خطأ في جلب الدكاترة: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Exception while fetching doctors: $e");
    }
  }

  void updateAvailableTimes() {
    if (selectedDoctorId == null || selectedDate == null) return;

    final doctor = doctors.firstWhere((d) => d['id'] == selectedDoctorId);
    final workHours = doctor['work_hours']?.split('-').map((s) => s.trim()).toList() ?? ['10:00','16:00'];
    final startHour = int.parse(workHours[0].split(':')[0]);
    final endHour = int.parse(workHours[1].split(':')[0]);

    List<String> times = [];
    for (int h = startHour; h <= endHour; h++) {
      if (h == endHour) {
        times.add('${h.toString().padLeft(2,'0')}:00');
      } else {
        times.add('${h.toString().padLeft(2,'0')}:00');
        times.add('${h.toString().padLeft(2,'0')}:30');
      }
    }

    final now = DateTime.now();
    if (selectedDate!.year == now.year &&
        selectedDate!.month == now.month &&
        selectedDate!.day == now.day) {
      times = times.where((t) {
        final tParts = t.split(':');
        final dt = DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
            int.parse(tParts[0]),
            int.parse(tParts[1]));
        return dt.isAfter(now);
      }).toList();
    }

    setState(() {
      availableTimes = times;
      selectedTime = null;
    });
  }

  Future<void> pickDate() async {
    if (selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار الطبيب أولاً')));
      return;
    }

    final doctor = doctors.firstWhere((d) => d['id'] == selectedDoctorId);
    final allowedDays = doctor['days'] ?? ["Sunday","Monday","Tuesday","Wednesday","Thursday"];

    DateTime initial = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final dayName = DateFormat('EEEE').format(initial.add(Duration(days: i)));
      if (allowedDays.contains(dayName)) {
        initial = initial.add(Duration(days: i));
        break;
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      selectableDayPredicate: (date) {
        String dayName = DateFormat('EEEE').format(date);
        return allowedDays.contains(dayName);
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: PatientTheme.primaryColor, // AppBar و أزرار التاريخ
              onPrimary: PatientTheme.buttonTextColor, // نص التاريخ
              onSurface: PatientTheme.textPrimary, // النصوص داخل التقويم
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        updateAvailableTimes();
      });
    }
  }
  Future<bool> hasExistingAppointment() async {
    final url = Uri.parse(AppointmentsMy);
    try {
      final res = await http.get(url, headers: {
        "Authorization": "Bearer ${widget.token}",
        "Content-Type": "application/json",
      });
      if (res.statusCode == 200) {
        final appointments = json.decode(utf8.decode(res.bodyBytes));
        return appointments.isNotEmpty; // إذا يوجد أي موعد، ترجع true
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error checking existing appointments: $e");
      return false;
    }
  }

  Future<void> bookAppointment() async {
    bool hasAppointment = await hasExistingAppointment();
    if (hasAppointment) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚫 لديك موعد بالفعل، لا يمكنك الحجز مرة أخرى'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // نوقف عملية الحجز
    }

    if (selectedDoctorId == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار الطبيب والتاريخ والوقت')));
      return;
    }

    // باقي كود الحجز كما هو
    final dtParts = selectedTime!.split(':');
    final appointmentDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      int.parse(dtParts[0]),
      int.parse(dtParts[1]),
    );

    setState(() => isLoading = true);

    final uri = Uri.parse(AppointmentsBook).replace(queryParameters: {
      "doctor_id": selectedDoctorId!,
      "date_time": appointmentDateTime.toIso8601String(),
      "reason": reasonController.text,
    });

    try {
      final res = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حجز الموعد بنجاح ✅')),
        );
        Navigator.pop(context);
      } else {
        final error = json.decode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: ${error["detail"] ?? "حدث خطأ"}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء الحجز')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:  Text('حجز مواعد',  style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      backgroundColor: PatientTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'اختر الطبيب',
                labelStyle: TextStyle(color: PatientTheme.textPrimary),
                border: const OutlineInputBorder(),
              ),
              dropdownColor: PatientTheme.cardColor,
              items: doctors
                  .map((doc) => DropdownMenuItem<String>(
                value: doc['id'].toString(),
                child: Text(
                  '${doc['full_name'] ?? "-"} - ${doc['email'] ?? "-"}',
                  style: TextStyle(color: PatientTheme.textPrimary),
                ),
              ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedDoctorId = val;
                  selectedDate = null;
                  selectedTime = null;
                  availableTimes = [];
                });
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                selectedDate == null
                    ? 'اختر التاريخ'
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
                style: TextStyle(color: PatientTheme.textPrimary),
              ),
              trailing: Icon(Icons.calendar_today, color: PatientTheme.iconColor),
              onTap: pickDate,
            ),
            const SizedBox(height: 20),
            if (availableTimes.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'اختر الوقت',
                  labelStyle: TextStyle(color: PatientTheme.textPrimary),
                  border: const OutlineInputBorder(),
                ),
                dropdownColor: PatientTheme.cardColor,
                value: selectedTime,
                items: availableTimes
                    .map((t) => DropdownMenuItem<String>(
                  value: t,
                  child: Text(t, style: TextStyle(color: PatientTheme.textPrimary)),
                ))
                    .toList(),
                onChanged: (val) => setState(() => selectedTime = val),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'سبب الموعد',
                labelStyle: TextStyle(color: PatientTheme.textSecondary),
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: bookAppointment,
              icon: const Icon(Icons.check_circle),
              label: const Text('تأكيد الحجز'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PatientTheme.buttonColor,
                foregroundColor: PatientTheme.buttonTextColor,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../core/config/app_config.dart';
//
// class BookAppointmentPage extends StatefulWidget {
//   final String userId;
//   final String token; // ✅ التوكن
//
//   const BookAppointmentPage({super.key, required this.userId, required this.token});
//
//   @override
//   State<BookAppointmentPage> createState() => _BookAppointmentPageState();
// }
//
// class _BookAppointmentPageState extends State<BookAppointmentPage> {
//   List doctors = [];
//   String? selectedDoctorId;
//   DateTime? selectedDate;
//   String? selectedTime;
//   TextEditingController reasonController = TextEditingController();
//   List<String> availableTimes = [];
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDoctors();
//   }
//
//   // ------------------- جلب قائمة الدكاترة -------------------
//   Future<void> fetchDoctors() async {
//     try {
//       final url = Uri.parse(AppointmentsBook); // نفس endpoint للحجز، السيرفر يعيد قائمة الدكاترة
//       print("🔹 Fetching doctors from: $url");
//
//       final res = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${widget.token}', // ✅ الهيدر
//       });
//
//       print("🔹 Response Status: ${res.statusCode}");
//       print("🔹 Response Body: ${res.body}");
//
//       if (res.statusCode == 200) {
//         setState(() {
//           doctors = json.decode(utf8.decode(res.bodyBytes)); // ✅ UTF-8
//         });
//         print("🔹 Doctors fetched: $doctors");
//       } else {
//         print("⚠️ خطأ في جلب الدكاترة: ${res.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Exception while fetching doctors: $e");
//     }
//   }
//
//   // ------------------- تحديث الأوقات المتاحة -------------------
//   void updateAvailableTimes() {
//     if (selectedDoctorId == null || selectedDate == null) return;
//
//     final doctor = doctors.firstWhere((d) => d['id'] == selectedDoctorId);
//     final workHours = doctor['work_hours']?.split('-').map((s) => s.trim()).toList() ?? ['10:00','16:00'];
//     final startHour = int.parse(workHours[0].split(':')[0]);
//     final endHour = int.parse(workHours[1].split(':')[0]);
//
//     List<String> times = [];
//     for (int h = startHour; h <= endHour; h++) {
//       if (h == endHour) {
//         times.add('${h.toString().padLeft(2,'0')}:00');
//       } else {
//         times.add('${h.toString().padLeft(2,'0')}:00');
//         times.add('${h.toString().padLeft(2,'0')}:30');
//       }
//     }
//
//     // إزالة الأوقات السابقة إذا اليوم نفسه
//     final now = DateTime.now();
//     if (selectedDate!.year == now.year &&
//         selectedDate!.month == now.month &&
//         selectedDate!.day == now.day) {
//       times = times.where((t) {
//         final tParts = t.split(':');
//         final dt = DateTime(
//             selectedDate!.year,
//             selectedDate!.month,
//             selectedDate!.day,
//             int.parse(tParts[0]),
//             int.parse(tParts[1]));
//         return dt.isAfter(now);
//       }).toList();
//     }
//
//     setState(() {
//       availableTimes = times;
//       selectedTime = null;
//     });
//     print("🔹 Available times updated: $availableTimes");
//   }
//
//   // ------------------- اختيار التاريخ -------------------
//   Future<void> pickDate() async {
//     if (selectedDoctorId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('يرجى اختيار الطبيب أولاً')));
//       return;
//     }
//
//     final doctor = doctors.firstWhere((d) => d['id'] == selectedDoctorId);
//     final allowedDays = doctor['days'] ?? ["Sunday","Monday","Tuesday","Wednesday","Thursday"];
//
//     DateTime initial = DateTime.now();
//     for (int i = 0; i < 30; i++) {
//       final dayName = DateFormat('EEEE').format(initial.add(Duration(days: i)));
//       if (allowedDays.contains(dayName)) {
//         initial = initial.add(Duration(days: i));
//         break;
//       }
//     }
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//       selectableDayPredicate: (date) {
//         String dayName = DateFormat('EEEE').format(date);
//         return allowedDays.contains(dayName);
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//         updateAvailableTimes();
//       });
//     }
//   }
//
//   // ------------------- حجز الموعد -------------------
//   Future<void> bookAppointment() async {
//     if (selectedDoctorId == null || selectedDate == null || selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('يرجى اختيار الطبيب والتاريخ والوقت')));
//       return;
//     }
//
//     final dtParts = selectedTime!.split(':');
//     final appointmentDateTime = DateTime(
//       selectedDate!.year,
//       selectedDate!.month,
//       selectedDate!.day,
//       int.parse(dtParts[0]),
//       int.parse(dtParts[1]),
//     );
//
//     setState(() => isLoading = true);
//
//     // 🔹 بناء URI بالـ query parameters
//     final uri = Uri.parse(AppointmentsBook).replace(queryParameters: {
//       "doctor_id": selectedDoctorId!,
//       "date_time": appointmentDateTime.toIso8601String(),
//       "reason": reasonController.text,
//     });
//
//     print("🔹 Booking appointment:");
//     print("Doctor ID: $selectedDoctorId");
//     print("DateTime: $appointmentDateTime");
//     print("Reason: ${reasonController.text}");
//     print("🔹 Request URI: $uri");
//
//     try {
//       final res = await http.post(
//         uri,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer ${widget.token}",
//         },
//       );
//
//       print("🔹 Response Status: ${res.statusCode}");
//       print("🔹 Response Body: ${res.body}");
//
//       if (res.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('تم حجز الموعد بنجاح ✅')),
//         );
//         Navigator.pop(context); // إغلاق الصفحة بعد الحجز
//       } else {
//         final error = json.decode(res.body);
//         print("❌ Error detail: $error");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('خطأ: ${error["detail"] ?? "حدث خطأ"}')),
//         );
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('حدث خطأ أثناء الحجز')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar:
//       // AppBar(title: const Text('حجز موعد'), backgroundColor: Colors.teal),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 labelText: 'اختر الطبيب',
//                 border: OutlineInputBorder(),
//               ),
//               items: doctors
//                   .map((doc) => DropdownMenuItem<String>(
//                 value: doc['id'].toString(),
//                 child: Text('${doc['full_name'] ?? "-"} - ${doc['email'] ?? "-"}'),
//               ))
//                   .toList(),
//               onChanged: (val) {
//                 setState(() {
//                   selectedDoctorId = val;
//                   selectedDate = null;
//                   selectedTime = null;
//                   availableTimes = [];
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               title: Text(selectedDate == null
//                   ? 'اختر التاريخ'
//                   : DateFormat('yyyy-MM-dd').format(selectedDate!)),
//               trailing: const Icon(Icons.calendar_today),
//               onTap: pickDate,
//             ),
//             const SizedBox(height: 20),
//             if (availableTimes.isNotEmpty)
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: 'اختر الوقت',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: selectedTime,
//                 items: availableTimes
//                     .map((t) => DropdownMenuItem<String>(
//                   value: t,
//                   child: Text(t),
//                 ))
//                     .toList(),
//                 onChanged: (val) => setState(() => selectedTime = val),
//               ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: reasonController,
//               decoration: const InputDecoration(
//                 labelText: 'سبب الموعد',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 2,
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton.icon(
//               onPressed: bookAppointment,
//               icon: const Icon(Icons.check_circle),
//               label: const Text('تأكيد الحجز'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
