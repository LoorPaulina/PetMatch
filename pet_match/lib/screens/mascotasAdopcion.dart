import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_match/components/MascotaCard.dart';
import 'package:pet_match/components/Searcher.dart';
import 'package:pet_match/models/mascotas.dart';
import '../constants.dart';

class Mascotasadopcion extends StatefulWidget {
  @override
  _MascotasAdopcionState createState() => _MascotasAdopcionState();
}

class _MascotasAdopcionState extends State<Mascotasadopcion> {
  List<Animal> mascotas = [];
  String selectedTipo = 'Todos';
  String selectedAntiguedad = 'Todos';

  @override
  void initState() {
    super.initState();
    _getMascotas();
  }

  Future<void> _getMascotas() async {
    try {
      final response =
          await Dio().get('${urlBack}getMascotas', queryParameters: {
        'tipo': selectedTipo != 'Todos' ? selectedTipo : null,
        'antiguedad': selectedAntiguedad != 'Todos' ? selectedAntiguedad : null,
      });

      List<Animal> fetchedMascotas = [];
      for (var item in response.data["data"]) {
        Animal mascota = Animal.fromJson(item);
        fetchedMascotas.add(mascota);
      }

      setState(() {
        mascotas = fetchedMascotas;
        mascotasFetched = mascotas;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onFilterChanged(String tipo, String antiguedad) {
    setState(() {
      selectedTipo = tipo;
      selectedAntiguedad = antiguedad;
    });
    _getMascotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mascotas en Adopción"),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: ListView.builder(
              itemCount: mascotas.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, index) {
                final mascota = mascotas[index];
                return Mascotacard(
                  url: mascota.photoUrl ?? 'assets/mascotas/default.png',
                  nombre: mascota.nombre,
                  peso: mascota.peso?.toString() ?? 'Desconocido',
                  edad: mascota.edadEnTexto(),
                  enAdopcionDesde: mascota.antiguedadEnTexto(),
                  sexo: mascota.sexo,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdownButton(
            label: 'Categoría',
            value: selectedTipo,
            items: ['Todos', 'Perro', 'Gato', 'Hamster'],
            onChanged: (value) => _onFilterChanged(value!, selectedAntiguedad),
          ),
          const SizedBox(height: 16),
          _buildDropdownButton(
            label: 'Antigüedad en Adopción',
            value: selectedAntiguedad,
            items: [
              'Todos',
              'Mayor a 1 mes',
              'Mayor a 3 meses',
              'Mayor a 6 meses',
              'Mayor a 1 año'
            ],
            onChanged: (value) => _onFilterChanged(selectedTipo, value!),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text('Selecciona $label'),
          isExpanded: true,
        ),
      ],
    );
  }
}
