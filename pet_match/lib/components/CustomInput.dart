import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';

class Custominput extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const Custominput({required this.label, super.key, required this.controller});

  @override
  CustominputState createState() => CustominputState();
}

class CustominputState extends State<Custominput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black, // Border color
            width: 1.0, // Border width
          ),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: secundaryColor, // Set the color of the label text
          ),
          border: InputBorder.none, // Removes the default border
          contentPadding: EdgeInsets.zero, // Removes extra padding
        ),
      ),
    );
  }
}
