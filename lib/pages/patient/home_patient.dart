import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:university_project/pages/patient/my_appointments_page.dart';
import '../../core/config/theme.dart';
import 'book_appointment_page.dart';
import 'upload_image.dart';
import 'results_page.dart';
import 'profile_patient.dart';

class HomePatientPage extends StatefulWidget {
  final String token;

  const HomePatientPage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePatientPage> createState() => _HomePatientPageState();
}

class _HomePatientPageState extends State<HomePatientPage> {
  int _selectedIndex = 0;
  late String userId;

  @override
  void initState() {
    super.initState();
    final decodedToken = JwtDecoder.decode(widget.token);
    userId = decodedToken['sub']?.toString() ??
        decodedToken['user_id']?.toString() ??
        decodedToken['id']?.toString() ??
        '';
    print('🔹 Decoded Token: $decodedToken');
  }

  late final List<Widget> _pages = [
    _buildDashboard(context),
    MessagesPage(),
    MyAppointmentsPage(token: widget.token),
    ProfilePatientPage(
      token: widget.token,
    ),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.patientBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.patientBackground,
        title: Text(
          _selectedIndex == 0
              ? '🏠 الصفحة الرئيسية'
              : _selectedIndex == 1
                  ? '💬 الرسائل'
                  : _selectedIndex == 2
                      ? '📅 حجز موعد'
                      : '👤 Patient Profile',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                Icon(Icons.notifications, color: AppTheme.patientIcon),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🔔 لا توجد إشعارات حالياً')),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.patientPrimary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor:  AppTheme.patientBackground,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined), label: 'الرسائل'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'مواعيد'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'الملف الشخصي'),
        ],
      ),
    );
  }

  // ---------- الصفحة الرئيسية (Dashboard) ----------
  Widget _buildDashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, Patient',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.patientText,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Here you can manage your appointments, upload images for analysis, and view results easily.',
            style: TextStyle(fontSize: 16, color: AppTheme.patientText),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                // _buildFeatureCard(
                //   context,
                //   title: 'My Appointments',
                //   icon: Icons.calendar_today,
                //   color: PatientTheme.primaryColor,
                //   page: AppointmentsPatientPage(),
                // ),
                _buildFeatureCard(
                  context,
                  title: 'Book Appointment',
                  icon: Icons.add_circle_outline,
                  color: AppTheme.patientText,
                  page:
                      BookAppointmentPage(userId: userId, token: widget.token),
                ),
                // _buildFeatureCard(
                //   context,
                //   title: 'Upload Image',
                //   icon: Icons.upload_file,
                //   color: PatientTheme.buttonColor,
                //   page: const UploadImagePage(),
                // ),
                // _buildFeatureCard(
                //   context,
                //   title: 'Results',
                //   icon: Icons.bar_chart_outlined,
                //   color: PatientTheme.buttonColor,
                //   page: const ResultsPage(),
                // ),
                // _buildFeatureCard(
                //   context,
                //   title: 'Profile',
                //   icon: Icons.person_outline,
                //   color: PatientTheme.primaryColor,
                //   page: const ProfilePatientPage(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- تصميم الكروت ----------
  Widget _buildFeatureCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required Widget page}) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
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
}

// ---------- صفحة الرسائل ----------
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '📨 لا توجد رسائل حالياً',
        style: TextStyle(fontSize: 18, color:AppTheme.patientText),
      ),
    );
  }
}
