import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:university_project/pages/auth/configration.dart';
import 'package:university_project/pages/patient/home_patient.dart';
import 'login.dart';
import 'package:university_project/pages/auth/register_doctor.dart';

class RegisterPatientPage extends StatefulWidget {
  const RegisterPatientPage({Key? key}) : super(key: key);

  @override
  State<RegisterPatientPage> createState() => _RegisterPatientPageState();
}

class _RegisterPatientPageState extends State<RegisterPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  bool _isLoading = false;
  bool loading = false;

  Future<void> registerPatient() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}patients/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _email.text.trim(),
          "username": _email.text.split('@')[0],
          "first_name": _firstName.text.trim(),
          "last_name": _lastName.text.trim(),
          "password": _password.text.trim(),
          "role": "patient",
          "phone_number": _phone.text.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Registered successfully")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Error: ${error['detail'] ?? 'Registration failed'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
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
              leading: Icon(Icons.local_hospital_outlined),
              title: Text('Doctor'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterDoctorPage()),
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
        title: Text('Register as Patient'),
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
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextFormField(
                      controller: _firstName,
                      labelText: "First Name",
                      prefixIcon: Icons.person_outline,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your first name" : null,
                    ),
                    SizedBox(height: 12),
                    buildTextFormField(
                      controller: _lastName,
                      labelText: "Last Name",
                      prefixIcon: Icons.person_outline,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your last name" : null,
                    ),
                    SizedBox(height: 12),
                    buildTextFormField(
                      controller: _email,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your email" : null,
                    ),
                    SizedBox(height: 12),
                    buildTextFormField(
                      controller: _phone,
                      labelText: "Phone Number",
                      prefixIcon: Icons.phone,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your phone number" : null,
                    ),
                    SizedBox(height: 12),
                    buildTextFormField(
                      controller: _password,
                      labelText: "Password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your password" : null,
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
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.teal.shade600;
                                    return null;
                                  },
                                ),
                              ),
                              onPressed: loading ? null : registerPatient,
                              child: loading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        backgroundColor: Colors.teal.shade600,
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
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 20),
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
            ],
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
    bool _isObscured = obscureText;

    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          obscureText: _isObscured,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.teal.shade600),
            prefixIcon: Icon(prefixIcon, color: Colors.teal.shade600),
            suffixIcon: obscureText
                ? IconButton(
              icon: Icon(
                _isObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.teal.shade600,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            )
                : null,
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
      },
    );
  }

}

// import 'package:flutter/material.dart';
// import 'package:university_project/pages/auth/register_doctor.dart';
// import 'package:university_project/pages/auth/register_nurse.dart';
// import 'package:university_project/pages/patient/home_patient.dart';
// import 'login.dart';
//
// class RegisterPatientPage extends StatefulWidget {
//   const RegisterPatientPage({Key? key}) : super(key: key);
//
//   @override
//   State<RegisterPatientPage> createState() => _RegisterPatientPageState();
// }
//
// class _RegisterPatientPageState extends State<RegisterPatientPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _name = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   final TextEditingController _age = TextEditingController();
//
//   void _showRoleDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title:  Text('Choose another account type'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ListTile(
//             //   leading:  Icon(Icons.local_hospital_outlined),
//             //   title:  Text('Nurse'),
//             //   onTap: () {
//             //     Navigator.pop(context);
//             //     Navigator.pushReplacement(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (_) =>  RegisterNursePage(),
//             //       ),
//             //     );
//             //   },
//             // ),
//             ListTile(
//               leading:  Icon(Icons.local_hospital_outlined),
//               title:  Text('Doctor'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) =>  RegisterDoctorPage(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: Colors.teal.shade600,
//         title:  Text('Register as Patient'),
//         centerTitle: true,
//         leading: IconButton(
//           icon:  Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) =>  LoginPage()),
//             );
//           },
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           child: Column(
//             children: [
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _name,
//                       decoration: InputDecoration(
//                         labelText: 'Full Name',
//                         prefixIcon:  Icon(Icons.person_outline),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15)),
//                       ),
//                       validator: (val) =>
//                       val!.isEmpty ? 'Enter your name' : null,
//                     ),
//                      SizedBox(height: 12),
//                     TextFormField(
//                       controller: _email,
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         prefixIcon:  Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15)),
//                       ),
//                       validator: (val) =>
//                       val!.isEmpty ? 'Enter your email' : null,
//                     ),
//                      SizedBox(height: 12),
//                     TextFormField(
//                       controller: _age,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'Age',
//                         prefixIcon:  Icon(Icons.cake_outlined),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15)),
//                       ),
//                       validator: (val) =>
//                       val!.isEmpty ? 'Enter your age' : null,
//                     ),
//                      SizedBox(height: 12),
//                     TextFormField(
//                       controller: _password,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         prefixIcon:  Icon(Icons.lock_outline),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15)),
//                       ),
//                       validator: (val) =>
//                       val!.isEmpty ? 'Enter a password' : null,
//                     ),
//                      SizedBox(height: 20),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.teal.shade600,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                SnackBar(
//                                   content:
//                                   Text('Patient registered successfully')),
//
//                             );
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => HomePatientPage())
//                               // SearchPage()),
//                             );
//                           }
//                         },
//                         child:  Text(
//                           'Register',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                      SizedBox(height: 10),
//                     TextButton(
//                       onPressed: _showRoleDialog,
//                       child: Text(
//                         'Change account type',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                      SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                          Text("Already have an account?"),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) =>  LoginPage()),
//                             );
//                           },
//                           child:  Text('Login'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
