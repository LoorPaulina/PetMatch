// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  String msg;
  Usuario usuario;

  Welcome({
    required this.msg,
    required this.usuario,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        msg: json["msg"],
        usuario: Usuario.fromJson(json["usuario"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "usuario": usuario.toJson(),
      };
}

class Usuario {
  String apellido;
  String biografia;
  int cantidadDonaciones;
  String cartaMotivacional;
  int codigo;
  String contrasena;
  String email;
  String nombre;
  int numAdopciones;
  String ocupacion;
  String rolDePago;

  Usuario({
    required this.apellido,
    required this.biografia,
    required this.cantidadDonaciones,
    required this.cartaMotivacional,
    required this.codigo,
    required this.contrasena,
    required this.email,
    required this.nombre,
    required this.numAdopciones,
    required this.ocupacion,
    required this.rolDePago,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        apellido: json["apellido"],
        biografia: json["biografia"],
        cantidadDonaciones: json["cantidad_donaciones"],
        cartaMotivacional: json["carta_motivacional"],
        codigo: json["codigo"],
        contrasena: json["contrasena"],
        email: json["email"],
        nombre: json["nombre"],
        numAdopciones: json["num_adopciones"],
        ocupacion: json["ocupacion"],
        rolDePago: json["rol_de_pago"],
      );

  Map<String, dynamic> toJson() => {
        "apellido": apellido,
        "biografia": biografia,
        "cantidad_donaciones": cantidadDonaciones,
        "carta_motivacional": cartaMotivacional,
        "codigo": codigo,
        "contrasena": contrasena,
        "email": email,
        "nombre": nombre,
        "num_adopciones": numAdopciones,
        "ocupacion": ocupacion,
        "rol_de_pago": rolDePago,
      };
}
