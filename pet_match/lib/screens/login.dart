import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_match/components/CustomButton.dart';
import 'package:pet_match/components/CustomInput.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/screens/createAccount.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Future<void> log_in() async {
    final response = await http.post(
      Uri.parse("http:127.0.0.1:5000/login"),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _email.text,
        'password': _password.text,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        print(data['message']);
      } else {
        print(data['message']);
      }
    } else {
      print("Server error: ${response.statusCode}");
    }
  }

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
                  color: textColor,
                  fontSize: screenWidth * 0.08,
                  fontFamily: 'LexendDeca',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(235, 204, 210, 186),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(80),
                              topRight: Radius.circular(80),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Custominput(
                                label: "EMAIL",
                                controller: _email,
                              ),
                              SizedBox(height: screenHeight * 0.1),
                              Custominput(
                                label: "CONTRASEÑA",
                                controller: _password,
                              ),
                              SizedBox(height: screenHeight * 0.1),
                              //deberia ser un stack

                              Container(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      CustomButton(
                                        text: "   INICIAR SESIÓN   ",
                                        onPressed: () async {
                                          await log_in();
                                        },
                                        backgroundColor: textColor,
                                        textColor: Colors.white,
                                        borderRadius: 10.0,
                                        elevation: 5.0,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomButton(
                                        text: "     REGISTRARSE    ",
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateAccount()),
                                          );
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
                              // Add more widgets or buttons here as needed
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          child: Image.asset(
                            "assets/front_dog.png",
                            width: 210,
                            height: 200,
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
