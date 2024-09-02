import 'package:intl/intl.dart';

class Animal {
  int codigo;
  String nombre;
  DateTime? fechaNacimiento;
  double? peso;
  String sexo;
  String estadoAdopcion;
  double? altura;
  String? especie;
  String? photoUrl;
  DateTime? enAdopcionDesde;
  String historia;

  Animal({
    required this.codigo,
    required this.nombre,
    this.fechaNacimiento,
    this.peso,
    required this.sexo,
    required this.estadoAdopcion,
    this.altura,
    this.especie,
    this.photoUrl,
    this.enAdopcionDesde,
    this.historia = "Sin historia disponible",
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    return Animal(
      codigo: json["codigo"],
      nombre: json["nombre"],
      fechaNacimiento: json["fecha_nacimiento"] != null
          ? dateFormat.parse(json["fecha_nacimiento"])
          : null,
      peso: json["peso"]?.toDouble(),
      sexo: json["sexo"],
      estadoAdopcion: json["estado_adopcion"],
      altura: json["altura"]?.toDouble(),
      especie: json["especie"],
      photoUrl: json["photo_url"],
      enAdopcionDesde: json["en_adopcion_desde"] != null
          ? dateFormat.parse(json["en_adopcion_desde"])
          : null,
      historia: json["historia"],
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    return {
      "codigo": codigo,
      "nombre": nombre,
      "fecha_nacimiento":
          fechaNacimiento != null ? dateFormat.format(fechaNacimiento!) : null,
      "peso": peso,
      "sexo": sexo,
      "estado_adopcion": estadoAdopcion,
      "altura": altura,
      "especie": especie,
      "photo_url": photoUrl,
      "en_adopcion_desde":
          enAdopcionDesde != null ? dateFormat.format(enAdopcionDesde!) : null,
      "historia": historia,
    };
  }

  int calcularEdad() {
    if (fechaNacimiento == null) {
      return 0;
    }
    final now = DateTime.now();
    final edad = now.year - fechaNacimiento!.year;
    final esCumpleanosHoy =
        now.month == fechaNacimiento!.month && now.day == fechaNacimiento!.day;

    return esCumpleanosHoy ? edad : edad - 1;
  }

  String edadEnTexto() {
    return "${calcularEdad()} años";
  }

  int calcularMesesEnAdopcion() {
    if (enAdopcionDesde == null) {
      return 0;
    }
    final now = DateTime.now();
    final diferencia = now.difference(enAdopcionDesde!);
    final meses = (diferencia.inDays / 30).floor(); //aproximo a 30 días
    return meses;
  }

  String antiguedadEnTexto() {
    final meses = calcularMesesEnAdopcion();
    if (meses < 1) {
      return "Menos de un mes";
    } else if (meses == 1) {
      return "1 mes";
    } else {
      return "$meses meses";
    }
  }
}
