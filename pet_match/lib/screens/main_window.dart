import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/models/users.dart';

class MainWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main Window")),
      body: Center(
        child: Text('usuario $usuario_loggeado.toJson()'),
      ),
    );
  }
}
