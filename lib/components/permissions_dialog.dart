// import 'package:flutter/material.dart';
// import 'package:login/services/login_api.dart';

// class PermissionsDialog extends StatelessWidget {
//   final Map<String, dynamic> userData;

//   const PermissionsDialog({super.key, required this.userData});

//   void sendNewPermissions(Map<String, dynamic> userData) async {
//     print('userData in sending $userData');
//     await addPermissions(userData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Center(
//         child: Container(
//           color: Colors.grey[200],
//           child: const Padding(
//             padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
//             child: Text('User Permissions'),
//           ),
//         ),
//       ),
//       content: SizedBox(
//         height: 300,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 const Text('User:'),
//                 const SizedBox(width: 10),
//                 Text(
//                   userData['email'],
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 )
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 const Text('Current Role:'),
//                 const SizedBox(width: 10),
//                 Text(
//                   userData['role'].toString(),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               // width: 50,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//                 child: TextField(
//                   decoration: const InputDecoration(
//                       border: InputBorder.none, hintText: 'change role'),
//                   onChanged: (newValue) {
//                     userData['role'] = newValue;
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 const Text('Current Branch ID\'s:'),
//                 const SizedBox(width: 10),
//                 Text(
//                   userData['branch_ids'].toString(),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//                 child: TextField(
//                   decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Enter a new branch ID'),
//                   onChanged: (newValue) {
//                     userData['branch_ids'] = newValue;
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             TextButton(
//               child: const Icon(Icons.cancel, color: Colors.red),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             Container(
//               width: 100,
//               height: 35,
//               color: Colors.grey[200],
//               child: TextButton(
//                 child:  const Text('Submit',style: TextStyle(color: Colors.black ),),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   sendNewPermissions(userData);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
