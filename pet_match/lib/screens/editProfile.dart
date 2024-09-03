import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _biografia = usuario_loggeado!.biografia;
  String _correo = usuario_loggeado!.email;
  String _contrasena = usuario_loggeado!.contrasena;
  String _ocupacion = usuario_loggeado!.ocupacion;

  Future<void> _updateAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await Dio().post(
          urlBack +
              'editAccount', // Reemplaza 'your_api_endpoint' con la URL de tu API
          data: {
            'email': _correo,
            'biografia': _biografia,
            'ocupacion': _ocupacion,
            'contrasena': _contrasena,
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Información guardada exitosamente')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar la información')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildProfileImage(),
              SizedBox(height: 20),
              _buildInfoText('Editar Información'),
              SizedBox(height: 20),
              _buildTextField(
                labelText: 'Biografía',
                initialValue: _biografia,
                onChanged: (value) => setState(() => _biografia = value),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              _buildTextField(
                labelText: 'Contraseña',
                initialValue: _contrasena,
                onChanged: (value) => setState(() => _contrasena = value),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña no puede estar vacía';
                  } else if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildTextField(
                labelText: 'Ocupación',
                initialValue: _ocupacion,
                onChanged: (value) => setState(() => _ocupacion = value),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  _updateAccount;
                  if (usuario_loggeado?.biografia != '') {
                    usuario_loggeado?.biografia = _biografia;
                  }

                  if (usuario_loggeado?.contrasena != '') {
                    usuario_loggeado?.contrasena = _contrasena;
                  }

                  if (usuario_loggeado?.ocupacion != '') {
                    usuario_loggeado?.ocupacion = _ocupacion;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Información guardada exitosamente')),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/mascotas/default.jpeg',
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String initialValue,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
