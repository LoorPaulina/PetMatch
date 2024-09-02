import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/screens/mascotaScreen.dart';

class Mascotacard extends StatelessWidget {
  final String url;
  final String nombre;
  final String edad;
  final String peso;
  final String enAdopcionDesde;
  final String sexo;
  const Mascotacard(
      {super.key,
      required this.url,
      required this.nombre,
      required this.edad,
      required this.peso,
      required this.enAdopcionDesde,
      required this.sexo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedMascota = nombre;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MascotaScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/mascotas/$url.jpeg',
                width: 100,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "En adopción hace: $enAdopcionDesde",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EDAD: $edad    PESO: ${peso}KG',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Icon(
                          sexo == 'F' ? Icons.female : Icons.male,
                          color: Colors.grey[600],
                          size: 16,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
