import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
   MyTextField({super.key, required this.label, required this.isPassword, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {

      },
      obscureText: isPassword,
      controller: controller,
      decoration:  InputDecoration(
        filled: true,
        border: OutlineInputBorder(),
        focusColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black
          )
        ),
        labelText: label,
      ),
    );
  }
}
