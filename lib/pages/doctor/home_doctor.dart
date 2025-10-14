import 'package:flutter/material.dart';
import 'patients_list.dart';
import 'review_ai_result.dart';
import 'profile_doctor.dart';

class HomeDoctorPage extends StatelessWidget {
  final String token; // ← أضف هذا السطر

  const HomeDoctorPage({Key? key, required this.token});
  Widget _buildFeatureCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Widget page,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Doctor Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Doctor 👨‍⚕️',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Manage your patients, review AI results, and view your profile easily.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // البطاقات الرئيسية للطبيب
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildFeatureCard(
                    context,
                    title: 'Patients List',
                    icon: Icons.people_outline,
                    color: Colors.teal,
                    page:  PatientsListPage(),
                  ),

                  _buildFeatureCard(
                    context,
                    title: 'Profile',
                    icon: Icons.person_outline,
                    color: Colors.purple,
                    page:  ProfileDoctorPage(token:token ,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
