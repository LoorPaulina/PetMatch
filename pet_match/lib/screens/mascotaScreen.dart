import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/models/historialMedico.dart';
import '../models/mascotas.dart';
import '../models/vacuna.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP
import 'package:googleapis_auth/auth_io.dart'; // Para manejar autenticación con Google APIs
import 'package:googleapis/calendar/v3.dart'
    as calendar; // Para usar Google Calendar API
import 'dart:convert';

class MascotaScreen extends StatefulWidget {
  @override
  _MascotaScreenState createState() => _MascotaScreenState();
}

class _MascotaScreenState extends State<MascotaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Animal mascota = Animal(codigo: 0, nombre: '', estadoAdopcion: '', sexo: '');
  String get nombre => mascota.nombre;
  HistorialMedico historialMedico = HistorialMedico(
      nombre: '', esterilizado: '', ultimaDesparasitacion: DateTime.now());

  Vacuna vacuna = Vacuna(nombre: '', vacuna: 'vacuna', fecha: DateTime.now());
  List<Vacuna> vacunas = [];
  final _clientId =
      '98333547243-3n5grd1s11i0c5f66qqmtukcdq4qc3bt.apps.googleusercontent.com';
  final _redirectUri = 'com.example.petmatch:/oauth2redirect';
  void getAnimalSeleccionado() {
    for (int i = 0; i < mascotasFetched.length; i++) {
      if (mascotasFetched[i].nombre == selectedMascota) {
        mascota = mascotasFetched[i];
      }
    }
  }

  Future<void> _getHistorialMedico() async {
    try {
      final response = await Dio().get('${urlBack}getHealthyRecord/$nombre');
      var data = response.data["data"];
      HistorialMedico mascotaHistorial = HistorialMedico.fromJson(data);
      setState(() {
        historialMedico = mascotaHistorial;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _Vacunas() async {
    try {
      final response = await Dio().get('${urlBack}getVacunas/$nombre');
      List<Vacuna> fetchedVacunas = [];

      for (var item in response.data["data"]) {
        Vacuna vacunaI = Vacuna.fromJson(item);
        fetchedVacunas.add(vacunaI);
      }

      setState(() {
        vacunas = fetchedVacunas;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addEventToGoogleCalendar() async {
    try {
      final url =
          'https://accounts.google.com/o/oauth2/auth?client_id=$_clientId&redirect_uri=$_redirectUri&response_type=code&scope=https://www.googleapis.com/auth/calendar.events';
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: 'com.yourapp',
      );

      final code = Uri.parse(result).queryParameters['code'];

      final tokenUrl = 'https://oauth2.googleapis.com/token';
      final response = await http.post(
        Uri.parse(tokenUrl),
        body: {
          'client_id': _clientId,
          'grant_type': 'authorization_code',
          'redirect_uri': _redirectUri,
          'code': code,
        },
      );

      final tokenData = json.decode(response.body);
      final accessToken = tokenData['access_token'];
      final expiry =
          DateTime.now().add(Duration(seconds: tokenData['expires_in']));

      final credentials = AccessCredentials(
        AccessToken('Bearer', accessToken, expiry),
        tokenData['refresh_token'],
        ['https://www.googleapis.com/auth/calendar.events'],
      );

      final client = authenticatedClient(http.Client(), credentials);
      final calendarApi = calendar.CalendarApi(client);

      final event = calendar.Event(
        summary: "Adopción de ${mascota.nombre}",
        start: calendar.EventDateTime(dateTime: DateTime.now()),
        end: calendar.EventDateTime(
            dateTime: DateTime.now().add(Duration(hours: 1))),
      );

      await calendarApi.events.insert(event, "primary");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Evento agregado al Google Calendar")),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al agregar el evento")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getAnimalSeleccionado();
    _getHistorialMedico();
    _Vacunas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secundaryColor,
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.08,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Perfil"),
            Tab(text: "Vacunas"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPerfilTab(),
          _buildVacunasTab(),
        ],
      ),
    );
  }

  Widget _buildPerfilTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/mascotas/${mascota.photoUrl}.jpeg',
                width: 400,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mascota.nombre,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'SIN RAZA',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  mascota.sexo == 'F' ? Icons.female : Icons.male,
                  color: Colors.grey[600],
                  size: 16,
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard('EDAD', mascota.edadEnTexto()),
                _buildInfoCard('ALTURA', '${mascota.altura.toString()} cm'),
                _buildInfoCard('PESO', '${mascota.peso.toString()} kg'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              mascota.historia,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(
                height: 20), // Añadir espacio fijo en lugar de Spacer
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secundaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _addEventToGoogleCalendar,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'ADOPTAR',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Lógica para donar
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'DONAR',
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
    );
  }

  Widget _buildVacunasTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vacunas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Eliminar Expanded aquí
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: vacunas.length,
                      itemBuilder: (context, index) {
                        final vacuna = vacunas[index];
                        return _buildVacunaRow(
                          vacuna.vacuna,
                          DateFormat("yyyy-MM-dd").format(vacuna.fecha),
                          index % 2 == 0 ? Colors.blue : Colors.orange,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _showVacunasAlert(),
                      child: _buildVerMas('VER TODAS LAS VACUNAS'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Desparasitación Interna',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDesparasitacionRow(
                        'Última desparasitación',
                        DateFormat("yyyy-MM-dd")
                            .format(historialMedico.ultimaDesparasitacion)
                            .toString(),
                        Colors.grey),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Esterilización',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDesparasitacionRow('Realizada:',
                        historialMedico.esterilizado, Colors.grey),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVacunaRow(String titulo, String subtitulo, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.brightness_1, color: color, size: 12),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              subtitulo,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesparasitacionRow(
      String titulo, String subtitulo, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.brightness_1, color: color, size: 12),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              subtitulo,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerMas(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _showVacunasAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Todas las Vacunas'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var vacuna in vacunas)
                  _buildVacunaRow(
                    vacuna.vacuna,
                    DateFormat("yyyy-MM-dd").format(vacuna.fecha),
                    vacunas.indexOf(vacuna) % 2 == 0
                        ? Colors.blue
                        : Colors.orange,
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
