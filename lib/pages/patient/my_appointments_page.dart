import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config/app_config.dart';
import '../../core/config/theme.dart';

class MyAppointmentsPage extends StatefulWidget {
  final String token;

  const MyAppointmentsPage({super.key, required this.token});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  List appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMyAppointments();
  }

  // ------------------- جلب مواعيد المستخدم -------------------
  Future<void> fetchMyAppointments() async {
    final url = Uri.parse(AppointmentsMy);
    try {
      final res = await http.get(url, headers: {
        "Authorization": "Bearer ${widget.token}",
        "Content-Type": "application/json",
      });

      if (res.statusCode == 200) {
        setState(() {
          appointments = json.decode(utf8.decode(res.bodyBytes));
          isLoading = false;
        });
      } else {
        throw Exception("فشل في جلب المواعيد");
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب المواعيد: $e");
      setState(() => isLoading = false);
    }
  }

  // ------------------- طلب إلغاء موعد -------------------
  Future<void> requestCancel(String appointmentId) async {
    final url = Uri.parse(AppointmentsCancelRequest + appointmentId);
    try {
      final res = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"]),
            backgroundColor: Colors.green,
          ),
        );
        fetchMyAppointments();
      } else {
        final error = json.decode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error["detail"] ?? "حدث خطأ"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء الطلب'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('مواعيدي'),
        backgroundColor: PatientTheme.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: PatientTheme.primaryColor))
          : appointments.isEmpty
          ? const Center(
        child: Text(
          'لا يوجد مواعيد حالياً 😴',
          style: TextStyle(fontSize: 18, color: PatientTheme.textSecondary),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appt = appointments[index];
          final status = appt['status'] ?? '-';
          final isPending = status == 'PendingCancellation';
          return Card(
            color: PatientTheme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                "👨‍⚕️ الطبيب: ${appt['doctor_name'] ?? '-'}",
                style: const TextStyle(
                  color: PatientTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🕒 التاريخ: ${appt['date_time'] ?? '-'}",
                      style: const TextStyle(color: PatientTheme.textSecondary)),
                  Text("📋 الحالة: $status",
                      style: TextStyle(
                          color: isPending ? Colors.orange : PatientTheme.textSecondary,
                          fontWeight: isPending ? FontWeight.bold : FontWeight.normal)),
                  Text("📝 السبب: ${appt['reason'] ?? '-'}",
                      style: const TextStyle(color: PatientTheme.textSecondary)),
                  const SizedBox(height: 10),
                  if (!isPending)
                    ElevatedButton.icon(
                      onPressed: () => requestCancel(appt['appointment_id']),
                      icon: const Icon(Icons.cancel),
                      label: const Text('طلب إلغاء الموعد'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
