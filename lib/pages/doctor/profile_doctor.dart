import 'package:flutter/material.dart';

class ProfileDoctorPage extends StatelessWidget {
   ProfileDoctorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:  Text(
          'Doctor Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
               SizedBox(height: 30),
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blue.shade100,
                child:  Icon(
                  Icons.person_outline,
                  size: 70,
                  color: Colors.blue,
                ),
              ),
               SizedBox(height: 20),
               Text(
                'Dr. Ahmad Khalid',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Radiology Specialist',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
               SizedBox(height: 30),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading:  Icon(Icons.email_outlined, color: Colors.blue),
                  title:  Text('Email'),
                  subtitle:  Text('ahmad.khalid@hospital.com'),
                ),
              ),
               SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading:
                   Icon(Icons.local_hospital_outlined, color: Colors.blue),
                  title:  Text('Department'),
                  subtitle:  Text('Radiology Department'),
                ),
              ),
               SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading:
                   Icon(Icons.phone_android_outlined, color: Colors.blue),
                  title:  Text('Phone'),
                  subtitle:  Text('+962 79 123 4567'),
                ),
              ),               SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon:  Icon(Icons.edit_outlined, color: Colors.white),
                    label:  Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon:  Icon(Icons.logout, color: Colors.white),
                    label:  Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
               SizedBox(height: 30),
            ],
          ),
        ),
      ),

      )   ;
  }
}
