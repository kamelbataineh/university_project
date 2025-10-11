import 'package:flutter/material.dart';
import 'package:university_project/pages/auth/register_doctor.dart';
import 'package:university_project/pages/auth/register_nurse.dart';
import 'package:university_project/pages/auth/register_patient.dart';

import '../doctor/home_doctor.dart';
import '../patient/home_patient.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String selectedRole = 'patient';
  void _showRegisterOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Choose account type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:  Icon(Icons.person_outline),
              title:  Text('Patient'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  RegisterPatientPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading:  Icon(Icons.local_hospital_outlined),
              title:  Text('Doctor'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  RegisterDoctorPage(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading:  Icon(Icons.medical_services_outlined),
            //   title:  Text('Nurse'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) =>  RegisterNursePage(),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }


  void _login() {
    if (_formKey.currentState!.validate()) {
      if (selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your role')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in as $selectedRole')),
      );

      if (selectedRole == 'patient') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  HomePatientPage()),
        );
      } else if (selectedRole == 'doctor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  HomeDoctorPage()),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
               SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Please enter your email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Please enter your password' : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Login as',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'patient',
                          child: Text('Patient'),
                        ),
                        DropdownMenuItem(
                          value: 'doctor',
                          child: Text('Doctor'),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectedRole = val!;
                        });
                      },
                      validator: (val) => val == null
                          ? 'Please select your role'
                          : null,
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: _showRegisterOptions,                    child: const Text('Register'),
                  ),
                ],
              ),],
          ),


        ),
      ),
    );
  }
}
//////rere