import 'package:intl/intl.dart';

class Vacuna {
  final String nombre;
  final String vacuna; // Cambiado a String para representar 'Sí' o 'No'
  final DateTime fecha;

  Vacuna({
    required this.nombre,
    required this.vacuna,
    required this.fecha,
  });

  factory Vacuna.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    return Vacuna(
        nombre: json['nombre'],
        vacuna: json['vacuna'],
        fecha: dateFormat.parse(json["fecha"]));
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'vacuna': vacuna,
      'fecha': DateFormat("yyyy-MM-dd").format(fecha),
    };
  }
}
