import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/models/users.dart';
import 'package:pet_match/screens/login.dart';
import 'package:pet_match/components/CustomButton.dart';
import 'package:pet_match/components/CustomInput.dart';
import 'package:pet_match/screens/donation_window.dart';
import 'package:pet_match/screens/main_window.dart';

class DonationSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: secundaryColor),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainWindow()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Contenedor inferior con el mismo color de fondo que la imagen del corgi
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                  color: principalColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  )), // Mismo color de fondo que la imagen del corgi
            ),
          ),
          // Contenido principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  "TE AGRADECEMOS!",
                  style: TextStyle(
                    color: secundaryColor,
                    fontSize: 24,
                    fontFamily: 'LexendDeca',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/pets-allowed.png', // Imagen del icono central de la patita
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  "DONACION EXITOSA!",
                  style: TextStyle(
                    color: secundaryColor,
                    fontSize: 18,
                    fontFamily: 'LexendDeca',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Gracias por tu generosidad! Gracias a ti, más perros y gatos tendrán una vida llena de amor y cuidados. ¡Tu donación hace la diferencia!",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontFamily: 'LexendDeca',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/front_dog.png', // Imagen del corgi, se recomienda que sea PNG con transparencia
                  width: 200,
                  height: 130,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
