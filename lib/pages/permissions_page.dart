// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:login/components/permissions_dialog.dart';
// import 'package:login/services/login_api.dart';

// class PermissionsPage extends StatefulWidget {
//   const PermissionsPage({super.key});

//   @override
//   State<PermissionsPage> createState() => _PermissionsPageState();
// }

// class _PermissionsPageState extends State<PermissionsPage> {
//   Object data = {};
//   final branchIdController = TextEditingController();
//   final roleController = TextEditingController();
//   final emailController = TextEditingController();
//   Map<String, dynamic> usersPermissions = {};

//   void getUser(String email) async {
//     if (email == '') {
//       showErrorMesg('Please enter an email');
//       return;
//     }
//     try {
//       Map<String, dynamic> data = {
//         'email': email,
//       };
//       usersPermissions = await getUserPermissions(data);
//       print('usersPermissions $usersPermissions');
//       if (usersPermissions['statusCode'] == 200) {
//         emailController.clear();
//         // ignore: use_build_context_synchronously
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return PermissionsDialog(userData: usersPermissions);
//           },
//         );
//       } else {
//         String emailError = usersPermissions['email'];
//         String errorMessage = emailError != '' ? '$emailError\n' : '';
//         showErrorMesg(errorMessage);
//       }
//     } catch (e) {
//       print('Failed to fetch data in getUser. Status code: $e');
//     }
//   }

//   void showErrorMesg(String mesg) {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               backgroundColor: const Color.fromARGB(255, 245, 95, 95),
//               title: Center(
//                   child: Text(
//                 mesg,
//                 style: const TextStyle(color: Colors.white),
//               )),
//             ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 193, 193, 193),
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey[900],
//         title: const Text('Permissions'),
//       ),
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           const Text(
//             'Permissions',
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             obscureText: false,
//             controller: emailController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Email',
//             ),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 getUser(emailController.text);
//               },
//               child: const Text('Search'))
//         ],
//       )),
//     );
//   }
// }
