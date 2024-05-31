import 'dart:convert';
import 'package:zagoom/elementos/InicioSesion/paginaprincipal.dart';
import 'package:zagoom/elementos/InicioSesion/registro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // AGREGADO 29/05/2024

////AGREGADO 29/05/2024: SE GUARDA EN SHARED PREFERENCES EL ID DE USUARIO REGISTRADO


class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final TextEditingController _correoTelefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp reMedio = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');//correo
  final RegExp contra = RegExp(r'^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])\S{8,}$');//contraseña
  int _idUser = 0;  //AGREGADO 29/05/2024

  Future<void> guardarUsuario() async {  //AGREGADO  29/05/2024
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('idUser',_idUser);
  }

Future<void> _login() async {
  if (!_validateInputs()) return;

  const String apiUrl = 'https://glorious-sparkle-development.up.railway.app/zagoom/login';
  final Map<String, String> data = {
    'correo': _correoTelefonoController.text,
    'password': _passwordController.text,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);

      if (userData['correo'] == _correoTelefonoController.text &&
          userData['password'] == _passwordController.text) {
        if (mounted) {
          _idUser = userData['idUser']; //AGREGADO 29/05/2024
          guardarUsuario();  //AGREGADO 29/05/2024
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
          );
        }
          }
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> errorData = json.decode(response.body);
      _showErrorMessage(errorData['message'] ?? 'No se ha identificado un registro');
    } else if (response.statusCode == 401) {
      _showErrorMessage('No autorizado');
    } else if (response.statusCode == 403) {
      _showErrorMessage('Prohibido');
    }else if (response.statusCode == 404) {
      _showErrorMessage('Not Found');
    }
     else {
      _showErrorMessage('Error desconocido: ${response.statusCode}');
    }
  } catch (e) {
    _showErrorMessage('Error: $e');
  }
}

 void _showErrorMessage(String message) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}


  bool _validateInputs() {
    if (!reMedio.hasMatch(_correoTelefonoController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo inválido')),
      );
      return false;
    }
    if (!contra.hasMatch(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una minúscula y un número')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'ZAGOOM',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                children: [
                  Center(
                    child: Text(
                      'Correo',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _correoTelefonoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Contraseña',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              /*TextButton(
                onPressed: () {},
                child: const Text('¿Olvidaste tu contraseña?'),
              ),*/
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: const Text('Iniciar sesión', style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(height: 30),
              const Divider(color: Color.fromRGBO(0, 0, 0, 1)),
              const SizedBox(height: 30),
              /*Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.Google,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  SignInButton(
                    Buttons.Facebook,
                    onPressed: () {},
                  ),
                ],
              ),*/
              //const SizedBox(height: 25),
              TextButton(
                onPressed: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Registro()));

                },
                child: const Text('No tienes una cuenta? Crea una'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
