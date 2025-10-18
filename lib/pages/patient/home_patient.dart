import 'package:flutter/material.dart';
import 'package:university_project/pages/patient/profile_patient.dart';
import 'appointments_patient.dart';
import 'book_appointment_page.dart';
import 'upload_image.dart';
import 'results_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePatientPage extends StatelessWidget {
  final String token;
  const HomePatientPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final String? userIdStr =
        decodedToken['sub']?.toString() ??
            decodedToken['user_id']?.toString() ??
            decodedToken['id']?.toString();

    final String userId = userIdStr ?? '';
    print('🔹 Decoded Token: $decodedToken');

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade600,
        title:  Text(
          'Patient',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Patient',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Here you can manage your appointments, upload images for analysis, and view results easily.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildFeatureCard(
                    context,
                    title: 'My Appointments',
                    icon: Icons.calendar_today,
                    color: Colors.teal,
                    page: AppointmentsPatientPage(),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Book Appointment',
                    icon: Icons.add_circle_outline,
                    color: Colors.green,
                    page: BookAppointmentPage(userId: userId,token: token,),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Upload Image',
                    icon: Icons.upload_file,
                    color: Colors.orange,
                    page: UploadImagePage(),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Results',
                    icon: Icons.bar_chart_outlined,
                    color: Colors.blue,
                    page: ResultsPage(),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Profile',
                    icon: Icons.person_outline,
                    color: Colors.purple,
                    page: ProfilePatientPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFeatureCard(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
             SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}


// 🔹 الفكرة العامة:
// هذه الصفحة تمثل لوحة تحكم (Dashboard / لوحة القيادة) للمريض بعد تسجيل الدخول.
// من خلالها يستطيع:
// 1. إدارة مواعيده الطبية️
// 2. رفع صور التحاليل أو الأشعة
// 3. عرض نتائج الفحوصات الطبية
// 4. الدخول إلى ملفه الشخصي
