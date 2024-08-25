import 'package:flutter/material.dart';
import 'package:pet_match/components/MascotaCard.dart';
import 'package:pet_match/components/Searcher.dart';

class Mascotasadopcion extends StatelessWidget {
  const Mascotasadopcion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mascotas")),
      body: Center(
        child: Column(
          children: [
            Searcher(),
            Mascotacard(),
            Mascotacard(),
            Mascotacard(),
            Mascotacard()
          ],
        ),
      ),
    );
  }
}
