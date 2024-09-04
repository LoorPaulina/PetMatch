import 'package:intl/intl.dart';

class HistorialMedico {
  final String nombre;
  final String esterilizado;
  final DateTime ultimaDesparasitacion;

  HistorialMedico({
    required this.nombre,
    required this.esterilizado,
    required this.ultimaDesparasitacion,
  });

  factory HistorialMedico.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    return HistorialMedico(
        nombre: json['nombre'],
        esterilizado: json['esterilizado'] == 1 ? 'Sí' : 'No',
        ultimaDesparasitacion:
            dateFormat.parse(json["ultima_desparasitacion"]));
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'esterilizado': esterilizado == 'Sí' ? 1 : 0,
      'ultima_desparasitacion':
          DateFormat("yyyy-MM-dd").format(ultimaDesparasitacion),
    };
  }
}
