import 'package:flutter/material.dart';


 void showErrorMesg(BuildContext context,String mesg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 245, 95, 95),
              title: Center(
                  child: Text(
                mesg,
                style: const TextStyle(color: Colors.white),
              )),
            ));
  }


void singupErrors(Map<String, dynamic> user, BuildContext context) {
  Navigator.pop(context);
  String emailError = user['email'];
  String passwordError = user['password'];

  String errorMessage = emailError != '' && passwordError != ''
      ? 'Email: $emailError\nPassword: $passwordError'
      : emailError != ''
          ? '$emailError\n'
          : passwordError != ''
              ? '$passwordError'
              : '';

  showErrorMesg(context, errorMessage);
}

