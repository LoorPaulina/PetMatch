import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/screens/profile.dart';
import 'package:pet_match/components/CustomButton.dart';
import 'package:pet_match/components/CustomInput.dart';

class FormularioDonanteScreen extends StatefulWidget {
  @override
  _FormularioDonanteScreen createState() => _FormularioDonanteScreen();
}

class _FormularioDonanteScreen extends State<FormularioDonanteScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? rolDePagoFileName;
  String? cartaDeMotivoFileName;

  Future<void> _pickFile(String field) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (field == 'rolDePago') {
          rolDePagoFileName = result.files.first.name;
        } else if (field == 'cartaDeMotivo') {
          cartaDeMotivoFileName = result.files.first.name;
        }
      });
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdoptanteScreen()),
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
              height: 150,
              decoration: BoxDecoration(
                color:
                    principalColor, // Mismo color de fondo que la imagen del corgi
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
          ),
          // Contenido principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "EMPECEMOS",
                    style: TextStyle(
                      color: secundaryColor,
                      fontSize: 24,
                      fontFamily: 'LexendDeca',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "TODOS LOS DATOS INGRESADOS SERÁN USADOS PARA ANALIZAR SU PERFIL COMO ADOPTANTE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontFamily: 'LexendDeca',
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          label: "NOMBRES",
                          controller: firstNameController,
                        ),
                        const SizedBox(height: 15),
                        Custominput(
                          label: "APELLIDOS",
                          controller: lastNameController,
                        ),
                        const SizedBox(height: 15),
                        Custominput(
                          label: "OCUPACION",
                          controller: occupationController,
                        ),
                        const SizedBox(height: 15),
                        Custominput(
                          label: "DESCRIPCION",
                          controller: descriptionController,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickFile('rolDePago'),
                                child: Row(
                                  children: [
                                    Icon(Icons.upload_file,
                                        color: secundaryColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      rolDePagoFileName ?? "ROL DE PAGO",
                                      style: TextStyle(
                                        color: secundaryColor,
                                        fontFamily: 'LexendDeca',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickFile('cartaDeMotivo'),
                                child: Row(
                                  children: [
                                    Icon(Icons.upload_file,
                                        color: secundaryColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      cartaDeMotivoFileName ??
                                          "CARTA DE MOTIVO",
                                      style: TextStyle(
                                        color: secundaryColor,
                                        fontFamily: 'LexendDeca',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                    text: "REGISTRAR ADOPTANTE",
                    onPressed: () {
                      //deberia hacer update en los datos del usuario pero por ahora solo regresa a el perfil de donante
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdoptanteScreen()),
                      );
                    },
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    borderRadius: 10.0,
                    elevation: 5.0,
                  ),
                  const SizedBox(height: 20),
                  Positioned(
                    child: Image.asset(
                      "assets/front_dog.png",
                      width: 210,
                      height: 200,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
