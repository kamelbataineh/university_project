import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/app_config.dart'; // تأكد من تعريف AppointmentsDoctor هنا

class DoctorAppointmentsPage extends StatefulWidget {
  final String token;

  const DoctorAppointmentsPage({super.key, required this.token});

  @override
  State<DoctorAppointmentsPage> createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage> {
  List appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  // ------------------- جلب مواعيد المرضى للدكتور الحالي -------------------
  Future<void> fetchAppointments() async {
    setState(() => isLoading = true);
    final url = Uri.parse(AppointmentsDoctor); // endpoint لمواعيد الدكتور الحالي

    print("🔹 Fetching appointments from: $url");

    try {
      final res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      });

      print("🔹 Response Status: ${res.statusCode}");
      print("🔹 Raw Response Body: ${res.body}");

      if (res.statusCode == 200) {
        final decoded = json.decode(utf8.decode(res.bodyBytes));
        print("🔹 Decoded JSON: $decoded");

        setState(() {
          appointments = decoded; // ⚡ قائمة المواعيد مباشرة
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تحميل المواعيد: ${res.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("❌ Exception while fetching appointments: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e")),
      );
    }
  }

  // ------------------- أيقونات الحالة -------------------
  Icon getStatusIcon(String status) {
    switch (status) {
      case "Cancelled":
        return const Icon(Icons.cancel, color: Colors.red);
      case "Completed":
        return const Icon(Icons.check, color: Colors.blue);
      default:
        return const Icon(Icons.check_circle, color: Colors.green);
    }
  }

  // ------------------- واجهة المستخدم -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("مواعيد مرضاي"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon:  Icon(Icons.refresh),
            onPressed: fetchAppointments,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? const Center(child: Text("لا يوجد مواعيد"))
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final app = appointments[index];
          final patientName = app['patient_name'] ?? "-";
          final dateTimeStr = app['date_time'] ?? "-";
          final status = app['status'] ?? "-";
          final reason = app['reason'] ?? "-";

          DateTime? parsedDate;
          try {
            parsedDate = DateTime.parse(dateTimeStr);
          } catch (_) {
            parsedDate = null;
          }

          return Card(
            margin:  EdgeInsets.all(10),
            child: ListTile(
              leading: getStatusIcon(status),
              title: Text("المريض: $patientName"),
              subtitle: Text(
                'الوقت: ${parsedDate != null ? DateFormat("yyyy-MM-dd HH:mm").format(parsedDate) : "-"}\n'
                    'الحالة: $status\n'
                    'سبب الحجز: $reason',
              ),
            ),
          );
        },
      ),
    );
  }
}
