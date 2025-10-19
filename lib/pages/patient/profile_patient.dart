import 'package:flutter/material.dart';
import '../../core/config/theme.dart';

class ProfilePatientPage extends StatelessWidget {
  const ProfilePatientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // 🎀 الصورة الرمزية للمريض
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: PatientTheme.primaryLight,
                  child: const Icon(
                    Icons.person_outline,
                    size: 70,
                    color: PatientTheme.iconColor,
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Text(
                'اسم المريض', // ممكن تغيّرها بالاسم من قاعدة البيانات
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: PatientTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 30),
              // 🩺 معلومات المريض داخل بطاقة
              Card(
                color: PatientTheme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: const [
                      ProfileItem(
                          title: '📧 البريد الإلكتروني',
                          value: 'patient@email.com'),
                      Divider(),
                      ProfileItem(
                          title: '📞 رقم الهاتف', value: '+962 7X XXX XXXX'),
                      Divider(),
                      ProfileItem(title: '⚧ الجنس', value: 'أنثى'),
                      Divider(),
                      ProfileItem(
                          title: '🎂 تاريخ الميلاد', value: '12 / 06 / 2000'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
              // 🔘 زر تسجيل الخروج
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PatientTheme.buttonColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🚪 تم تسجيل الخروج بنجاح')),
                  );
                },
                icon: const Icon(Icons.logout, color: PatientTheme.buttonTextColor),
                label: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color: PatientTheme.buttonTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileItem({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: PatientTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PatientTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
