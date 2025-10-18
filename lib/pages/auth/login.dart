import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:university_project/pages/auth/register_doctor.dart';
import 'package:university_project/pages/auth/register_patient.dart';
import '../doctor/home_doctor.dart';
import '../patient/home_patient.dart';
import 'configration.dart';

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
  bool loading = false;

  void _showRegisterOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose account type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Patient'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterPatientPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_hospital_outlined),
              title: Text('Doctor'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterDoctorPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final input = _email.text.trim();
    final password = _password.text.trim();

    final data = <String, String>{};
    if (RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(input)) {
      data['email'] = input;
    } else {
      data['username'] = input;
    }
    data['password'] = password;

    final loginUrl = selectedRole == 'doctor' ? doctorLogin : patientLogin;

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);

        final token = resBody["access_token"] ?? resBody["token"] ?? "";
        final doctorId = int.tryParse(resBody["doctor_id"].toString()) ?? 0;

        if (token.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orange,
              content: Text("لم يتم استلام التوكن من السيرفر."),
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Welcome ${selectedRole == 'doctor' ? 'Dr.' : ''} $input',
            ),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (selectedRole == 'patient') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomePatientPage(token: token),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeDoctorPage(
                  token: token,
                  doctorId: doctorId, // ← هنا نمرر int
                ),
              ),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "خطأ من السيرفر (${response.statusCode}): ${response.body}",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("فشل الاتصال بالسيرفر: $e"),
        ),
      );
    } finally {
      setState(() => loading = false);
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
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Please enter your email' : null,
                    ),
                     SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:  Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Please enter your password' : null,
                    ),
                     SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Login as',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items:  [
                        DropdownMenuItem(
                            value: 'patient', child: Text('Patient')),
                        DropdownMenuItem(
                            value: 'doctor', child: Text('Doctor')),
                      ],
                      onChanged: (val) => setState(() => selectedRole = val!),
                      validator: (val) =>
                      val == null ? 'Please select your role' : null,
                    ),
                     SizedBox(height: 25),
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
                        onPressed: loading ? null : _login,
                        child: loading
                            ?  CircularProgressIndicator(
                            color: Colors.white)
                            :  Text(
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
                    onPressed: _showRegisterOptions,
                    child:  Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
