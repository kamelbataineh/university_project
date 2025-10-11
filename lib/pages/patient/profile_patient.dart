import 'package:flutter/material.dart';

class ProfilePatientPage extends StatelessWidget {
  const ProfilePatientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title:  Text('My Profile',  style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.purple.shade100,
                child: const Icon(Icons.person_outline,
                    size: 70, color: Colors.purple),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Patient Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: const [
                    ProfileItem(title: 'Email', value: 'patient@email.com'),
                    Divider(),
                    ProfileItem(title: 'Phone', value: '+962 7X XXX XXXX'),
                    Divider(),
                    ProfileItem(title: 'Gender', value: 'Male'),
                    Divider(),
                    ProfileItem(title: 'Date of Birth', value: '12 / 06 / 2000'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {},
              icon:  Icon(Icons.logout,color: Colors.black,),
              label:  Text(
                'Logout',
                style: TextStyle(color:Colors.black,fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
