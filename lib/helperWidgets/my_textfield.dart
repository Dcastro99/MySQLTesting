import 'package:flutter/material.dart';

class MyTextfeild extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscuerText;
  final String? errorText;
  const MyTextfeild(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscuerText,
      required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscuerText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 200, 200, 200)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 200, 116, 79)),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          errorText: errorText,
        ),

      ),
    );
  }
}
