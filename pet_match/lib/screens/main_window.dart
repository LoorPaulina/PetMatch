import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/models/users.dart';
import 'package:pet_match/screens/login.dart';
import 'package:pet_match/screens/donation_window.dart';
import 'package:pet_match/screens/donation_success.dart';

class MainWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: Icon(
              Icons.close,
              color: secundaryColor,
            )),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/perfil.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Text(
                'Paulina Loor',
                style: TextStyle(
                  color: textColor,
                  fontSize: 8.0,
                  fontFamily: 'LexendDeca',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset("assets/gato.jpg"),
        ButtonWithImage(
          imagePath: "assets/paw.png",
          label: 'ADOPTAR',
          onPressed: () {
            //accion de adoptar
          },
        ),
        ButtonWithImage(
          imagePath: "assets/dollar-symbol.png",
          label: 'DONAR',
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DonationScreen()),
            );
          },
        ),
        ButtonWithImage(
          imagePath: "assets/user.png",
          label: 'PERFIL',
          onPressed: () {
            //accion de adoptar
          },
        ),
      ]),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cerrar sesión"),
          content: Text("¿Estás seguro de que quieres cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text("Cerrar sesión"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _logout(context); // Llama a la función de cierre de sesión
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    usuario_loggeado = null;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}

class ButtonWithImage extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const ButtonWithImage({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: textColor,
          foregroundColor: Colors.white,
          minimumSize: Size(200, 50), // Puedes ajustar el tamaño del botón
        ),
        icon: Image.asset(imagePath, width: 24, height: 24),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
