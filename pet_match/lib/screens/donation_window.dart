import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/models/users.dart';
import 'package:pet_match/screens/login.dart';
import 'package:pet_match/components/CustomButton.dart';
import 'package:pet_match/components/CustomInput.dart';
import 'package:pet_match/screens/main_window.dart';
import 'package:pet_match/screens/donation_success.dart';
import 'package:dio/dio.dart';

class DonationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  Future<void> _makeDonation(BuildContext context) async {
    Dio dio = Dio();
    // URL de tu endpoint en Flask
    final String url = "http://10.0.2.2:5000/registrarDonacion";
    int _codigoUsuario = usuario_loggeado!.codigo;
    String _montoDonacion = montoController.text;
    // Datos que se van a enviar
    final Map<String, dynamic> donationData = {
      'codigo': _codigoUsuario,
      'monto': _montoDonacion,
    };

    try {
      Response response = await dio.post(
        url,
        data: donationData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DonationSuccessScreen()),
        );
      } else {
        // Manejar errores
        print("Error: ${response.statusMessage}");
      }
    } catch (e) {
      // Manejo de excepciones
      print("Error al realizar la donación: $e");
    }
  }

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
            ); // Acción de cerrar
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "INGRESA MONTO A DONAR",
                  style: TextStyle(
                    color: secundaryColor,
                    fontSize: 18,
                    fontFamily: 'LexendDeca',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Custominput(
                  label: "MONTO",
                  controller: montoController,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "DATOS DE DONANTE",
                  style: TextStyle(
                    color: secundaryColor,
                    fontSize: 18,
                    fontFamily: 'LexendDeca',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: principalColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Custominput(
                      label: "NOMBRE DEL TITULAR",
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),
                    Custominput(
                      label: "NUMERO DE TARJETA",
                      controller: cardController,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/tarjetas.png',
                          width: 40,
                          height: 25,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Custominput(
                            label: "EXPIRACION",
                            controller: expirationController,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Custominput(
                            label: "CVV",
                            controller: cvvController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: "DONAR",
                onPressed: () => _makeDonation(context),
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                borderRadius: 10.0,
                elevation: 5.0,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/gato.jpg',
                  width: 400,
                  height: 300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
