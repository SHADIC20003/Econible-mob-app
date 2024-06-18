import 'package:flutter/material.dart';

class RoundTextField extends StatelessWidget {
  final String title;
  final TextAlign titleAlign;
  final TextEditingController controller;
  final TextInputType keyboardType;

  RoundTextField({
    required this.title,
    required this.titleAlign,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white), // Define the style here
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}