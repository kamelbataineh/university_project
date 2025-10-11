import 'package:flutter/material.dart';
import 'package:university_project/pages/auth/login.dart';
void main() async{

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// @override
//   void initState(){
//     super.initState();
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         print('User is currently signed out!');
//       } else {
//         print('User is signed in!');
//       }
//     });
//   }
//


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: "Userorrented",
      // onGenerateRoute: RouteClass.generator,
      home: LoginPage(),
    );

  }



}
