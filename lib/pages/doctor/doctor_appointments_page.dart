import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

const String baseUrl = "http://10.0.2.2:8000"; // 10.0.2.2 للمحاكي أندرويد

class DoctorAppointmentsPage extends StatefulWidget {
  final String token;

  const DoctorAppointmentsPage({super.key, required this.token});

  @override
  State<DoctorAppointmentsPage> createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage> {
  List doctors = [];
  String? selectedDoctorId;
  List appointments = [];
  bool isLoadingDoctors = true;
  bool isLoadingAppointments = false;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  // ------------------- جلب قائمة الدكاترة -------------------
  Future<void> fetchDoctors() async {
    final url = Uri.parse("$baseUrl/appointments/doctors");
    try {
      final res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      });

      if (res.statusCode == 200) {
        setState(() {
          doctors = json.decode(res.body);
          isLoadingDoctors = false;
          if (doctors.isNotEmpty) {
            selectedDoctorId = doctors[0]['id']; // أول دكتور تلقائي
            fetchAppointments();
          }
        });
      } else {
        setState(() => isLoadingDoctors = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تحميل الدكاترة: ${res.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => isLoadingDoctors = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e")),
      );
    }
  }

  // ------------------- جلب المواعيد -------------------
  Future<void> fetchAppointments() async {
    if (selectedDoctorId == null) return;

    setState(() => isLoadingAppointments = true);
    final url =
    Uri.parse("$baseUrl/appointments/doctor/$selectedDoctorId/appointments");

    try {
      final res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      });

      if (res.statusCode == 200) {
        setState(() {
          appointments = json.decode(res.body);
          isLoadingAppointments = false;
        });
      } else {
        setState(() => isLoadingAppointments = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تحميل المواعيد: ${res.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => isLoadingAppointments = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e")),
      );
    }
  }

  // ------------------- واجهة المستخدم -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مواعيد الدكتور"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchAppointments,
          ),
        ],
      ),
      body: isLoadingDoctors
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // قائمة اختيار الدكتور
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:DropdownButton<String>(
              value: selectedDoctorId ?? (doctors.isNotEmpty ? doctors[0]['id'] : null),
              items: doctors.map<DropdownMenuItem<String>>((doc) => DropdownMenuItem(
                value: doc['id'],
                child: Text(doc['full_name']),
              )).toList(),
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  selectedDoctorId = val;
                  fetchAppointments();
                });
              },
              isExpanded: true,
            )

          ),

          // المواعيد داخل Expanded
          Expanded(
            child: isLoadingAppointments
                ? const Center(child: CircularProgressIndicator())
                : appointments.isEmpty
                ? const Center(child: Text("لا يوجد مواعيد"))
                : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final app = appointments[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title:
                    Text("المريض: ${app['patient_name']}"),
                    subtitle: Text(
                      'الوقت: ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(app['date_time']))}\n'
                          'الحالة: ${app['status']}\n'
                          'سبب الحجز: ${app['reason'] ?? "-"}',
                    ),
                    trailing: Icon(
                      app['status'] == 'Cancelled'
                          ? Icons.cancel
                          : Icons.check_circle,
                      color: app['status'] == 'Cancelled'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
