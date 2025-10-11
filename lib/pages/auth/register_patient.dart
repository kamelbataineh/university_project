import 'package:flutter/material.dart';
import 'package:university_project/pages/auth/register_doctor.dart';
import 'package:university_project/pages/auth/register_nurse.dart';
import 'package:university_project/pages/patient/home_patient.dart';
import 'login.dart';

class RegisterPatientPage extends StatefulWidget {
  const RegisterPatientPage({Key? key}) : super(key: key);

  @override
  State<RegisterPatientPage> createState() => _RegisterPatientPageState();
}

class _RegisterPatientPageState extends State<RegisterPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _age = TextEditingController();

  void _showRoleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Choose another account type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ListTile(
            //   leading:  Icon(Icons.local_hospital_outlined),
            //   title:  Text('Nurse'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) =>  RegisterNursePage(),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading:  Icon(Icons.local_hospital_outlined),
              title:  Text('Doctor'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  RegisterDoctorPage(),
                  ),
                );
              },
            ),
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
        backgroundColor: Colors.teal.shade600,
        title:  Text('Register as Patient'),
        centerTitle: true,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) =>  LoginPage()),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon:  Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Enter your name' : null,
                    ),
                     SizedBox(height: 12),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:  Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Enter your email' : null,
                    ),
                     SizedBox(height: 12),
                    TextFormField(
                      controller: _age,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        prefixIcon:  Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Enter your age' : null,
                    ),
                     SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:  Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Enter a password' : null,
                    ),
                     SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                  content:
                                  Text('Patient registered successfully')),

                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePatientPage())
                              // SearchPage()),
                            );
                          }
                        },
                        child:  Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                     SizedBox(height: 10),
                    TextButton(
                      onPressed: _showRoleDialog,
                      child: Text(
                        'Change account type',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                     SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>  LoginPage()),
                            );
                          },
                          child:  Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
