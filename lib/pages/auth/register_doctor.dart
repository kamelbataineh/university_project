import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:university_project/pages/auth/register_patient.dart';
import 'configration.dart';
import 'login.dart';

class RegisterDoctorPage extends StatefulWidget {
  const RegisterDoctorPage({Key? key}) : super(key: key);

  @override
  State<RegisterDoctorPage> createState() => _RegisterDoctorPageState();
}

class _RegisterDoctorPageState extends State<RegisterDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  // final TextEditingController _specialization = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  bool loading = false;

  Future<void> registerDoctor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final Map<String, dynamic> data = {
      "username": _email.text.trim(),
      "email": _email.text.trim(),
      "first_name": _firstName.text.trim(),
      "last_name": _lastName.text.trim(),
      "password": _password.text.trim(),
      "role": "doctor",
      "phone_number": _phoneNumber.text.trim(),
      // "specialization": _specialization.text.trim(), // لو عندك حقل بالbackend
    };

    try {
      final response = await http.post(
        Uri.parse(doctorRegister),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      final resBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
                "${resBody["message"] ?? "Doctor registered successfully"}"
            ),
          ),
        );

        Future.delayed( Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) =>  LoginPage()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
                "${resBody["detail"] ?? "Registration failed"}"
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(" فشل الاتصال بالسيرفر: $e"),
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  void _showRoleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose another account type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Patient'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterPatientPage()),
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
        title: Text('Register as Doctor'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildTextFormField(
                  controller: _firstName,
                  labelText: 'First Name',
                  prefixIcon: Icons.person_outline,
                  validator: (val) => val!.isEmpty ? 'Enter your first name' : null,
                ),
                SizedBox(height: 12),
                buildTextFormField(
                  controller: _lastName,
                  labelText: 'Last Name',
                  prefixIcon: Icons.person_outline,
                  validator: (val) => val!.isEmpty ? 'Enter your last name' : null,
                ),
                SizedBox(height: 12),
                buildTextFormField(
                  controller: _email,
                  labelText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  validator: (val) => val!.isEmpty ? 'Enter your email' : null,
                ),
                SizedBox(height: 12),
                buildTextFormField(
                  controller: _phoneNumber,
                  labelText: 'Phone Number',
                  prefixIcon: Icons.phone,
                  validator: (val) => val!.isEmpty ? 'Enter phone number' : null,
                ),
                SizedBox(height: 12),
                buildTextFormField(
                  controller: _password,
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ).copyWith(
                            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.teal.shade600;
                                return null;
                              },
                            ),
                          ),
                          onPressed: loading ? null : registerDoctor,
                          child: loading
                              ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              backgroundColor:Colors.teal.shade600,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),
                    if (loading)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                  ],
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
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color:  Colors.teal.shade600),
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.teal.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.teal.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
        ),
      ),
      validator: validator,
    );
  }

}
