import 'package:intl/intl.dart';

class Evento {
  final String descripcion;
  final DateTime fecha;
  final String location;
  final String title;
  final String image;
  int likes;

  Evento({
    required this.descripcion,
    required this.fecha,
    required this.location,
    required this.title,
    required this.image,
    this.likes = 0,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    return Evento(
      descripcion: json['descripcion'],
      fecha: dateFormat.parse(json['fecha']),
      location: json['location'],
      title: json['title'],
      image: json['image'],
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      'fecha': DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(fecha),
      'location': location,
      'title': title,
      'image': image,
      'likes': likes,
    };
  }
}
