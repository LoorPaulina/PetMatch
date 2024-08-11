import 'package:flutter/material.dart';
import 'package:pet_match/components/CustomButton.dart';
import 'package:pet_match/components/CustomInput.dart';
import 'package:pet_match/constants.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.1),
        child: Center(
          child: Column(
            children: [
              Text(
                "Hola, bienvenido",
                style: TextStyle(
                    color: secundaryColor, fontSize: screenWidth * 0.07),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: principalColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Custominput(
                          label: "EMAIL",
                          controller: TextEditingController(),
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        Custominput(
                          label: "CONTRASEÑA",
                          controller: TextEditingController(),
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                CustomButton(
                                  text: "   INICIAR SESIÓN   ",
                                  onPressed: () {},
                                  backgroundColor: secundaryColor,
                                  textColor: Colors.white,
                                  borderRadius: 12.0,
                                  elevation: 5.0,
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  text: "     REGISTRARSE    ",
                                  onPressed: () {},
                                  backgroundColor:
                                      Color.fromARGB(255, 172, 167, 167),
                                  textColor: Colors.white,
                                  borderRadius: 12.0,
                                  elevation: 5.0,
                                ),
                              ],
                            ),
                          ),
                        )
                        // Add more widgets or buttons here as needed
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
