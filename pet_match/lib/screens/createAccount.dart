import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/components/CustomInput.dart';
import 'package:pet_match/components/CustomButton.dart';
import 'package:pet_match/screens/login.dart';
import 'package:pet_match/screens/main_window.dart';

class CreateAccount extends StatefulWidget {
  @override
  CreateAcountState createState() => CreateAcountState();
}

class CreateAcountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController email = TextEditingController();
    final TextEditingController userName = TextEditingController();
    final TextEditingController nombre = TextEditingController();
    final TextEditingController apellido = TextEditingController();
    final TextEditingController ocupacion = TextEditingController();
    final TextEditingController password = TextEditingController();

    void showError(String errorMessage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error!"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void showModal(String okMessage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Información"),
            content: Text(okMessage),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainWindow()));
                },
              ),
            ],
          );
        },
      );
    }

    Future<int> _createAccount() async {
      try {
        final response = await Dio().post(
          urlBack + 'createAccount',
          data: {
            "email": email.text,
            "username": userName.text,
            "nombre": nombre.text,
            "apellido": apellido.text,
            "ocupacion": ocupacion.text,
            "password": password.text
          },
        );
        if (response.statusCode == 200) {
          showModal("Cuenta creada con éxito");
        } else {
          showModal("Error al crear la cuenta");
        }
        return 200;
      } catch (e) {
        print(e);
        throw e;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Esto permite que la pantalla se ajuste cuando el teclado esté visible
      body: SingleChildScrollView(
        // Asegura que la pantalla sea desplazable cuando hay mucho contenido o el teclado aparece
        child: Container(
          height: screenHeight, // Hace que el contenido cubra toda la pantalla
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.1),
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: Navigator.of(context).pop,
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: secundaryColor,
                            )),
                        SizedBox(
                          width: screenWidth * 0.1,
                        ),
                        Text(
                          "Crea tu cuenta",
                          style: TextStyle(
                            color: textColor,
                            fontSize: screenWidth * 0.08,
                            fontFamily: 'LexendDeca',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, screenHeight * 0.04, 0, 0),
                    width: screenWidth,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(235, 204, 210, 186),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Custominput(
                          label: "EMAIL",
                          controller: email,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Custominput(
                          label: "USERNAME",
                          controller: userName,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Custominput(
                          label: "NOMBRE",
                          controller: nombre,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Custominput(
                          label: "APELLIDO",
                          controller: apellido,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Custominput(
                          label: "OCUPACIÓN",
                          controller: ocupacion,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Custominput(
                          label: "PASSWORD",
                          controller: password,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        SizedBox(
                          width: screenWidth / 1.3,
                          child: Padding(
                            padding: EdgeInsets.all(screenHeight * 0.04),
                            child: Column(
                              children: [
                                CustomButton(
                                  text: "     REGISTRARSE    ",
                                  onPressed: () async {
                                    if (email.text == '' ||
                                        userName.text == '' ||
                                        nombre.text == '' ||
                                        apellido.text == '' ||
                                        ocupacion.text == '' ||
                                        password.text == '') {
                                      showError(
                                          "Se deben llenar todos los campos.");
                                    } else {
                                      await _createAccount();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainWindow()),
                                      );
                                    }
                                  },
                                  backgroundColor:
                                      Color.fromARGB(255, 180, 180, 180),
                                  textColor: Colors.white,
                                  borderRadius: 10.0,
                                  elevation: 5.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
