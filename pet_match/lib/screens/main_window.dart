import 'package:flutter/material.dart';
import 'package:pet_match/models/users.dart';

class MainWindow extends StatelessWidget {
  final Usuario usuario;

  MainWindow({required this.usuario});

  @override
  Widget build(BuildContext context) {
    final datos = usuario.toJson();
    return Scaffold(
      appBar: AppBar(title: Text("Main Window")),
      body: Center(
        child: Text('usuario $datos'),
      ),
    );
  }
}
