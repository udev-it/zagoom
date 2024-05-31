import 'package:zagoom/elementos/InicioSesion/inicio.dart';
import 'package:zagoom/elementos/InicioSesion/paginaprincipal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // AGREGADO 29/05/2024

////AGREGADO 29/05/2024: SE GUARDA EN SHARED PREFERENCES EL ID DE USUARIO REGISTRADO

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwController = TextEditingController();
  final _telController = TextEditingController();
  final _apePController = TextEditingController();
  final _apeMController = TextEditingController();
  bool _passwordVisible = false;
  final RegExp reMedio = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$'); // correo
  final RegExp contra = RegExp(r'^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])\S{8,10}$'); // contraseña (mínimo 8, máximo 10 caracteres)
    int _idUser = 0; //AGREGADO 29/05/2024

  Future<void> guardarUsuario() async {  //AGREGADO  29/05/2024
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('idUser',_idUser);
  }

  Future<String?> addUser() async {
    final url = Uri.parse('https://glorious-sparkle-development.up.railway.app/zagoom/user');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': _nombreController.text,
        'apellidoPaterno': _apePController.text,
        'apellidoMaterno': _apeMController.text,
        'telefono': _telController.text,
        'correo': _correoController.text,
        'password': _passwController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> userData = json.decode(response.body); //AGREGADO 29/05/2024
      _idUser = userData['idUser']; //AGREGADO 29/05/2024
      guardarUsuario(); //AGREGADO 29/05/2024
      return null; // Éxito
    } else {
      return 'Error: Este correo ya fue registrado';
    }
  }


  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (!reMedio.hasMatch(value ?? '')) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.length < 8 || value.length > 10) {
      return 'Debe tener entre 8 y 10 caracteres';
    }
    if (!contra.hasMatch(value)) {
      return 'Debe tener al menos una letra mayúscula, una letra minúscula y un número';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Formulario de Registro",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Registro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color.fromARGB(255, 255, 106, 106),
          leading: IconButton(
            onPressed: () {
              print("back");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Inicio()));
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          /*actions: [
            IconButton(
              onPressed: () {
                print("info");
              },
              icon: const Icon(Icons.help_outline, color: Colors.white),
            )
          ],*/
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                const SizedBox(
                  child: Icon(Icons.person, size: 100),
                ),
                const SizedBox(height: 20),
                //const Text('Usuario: '),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: "Ingrese sus(s) nombres",
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _apePController,
                  decoration: const InputDecoration(
                    labelText: "Ingrese apellido paterno",
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _apeMController,
                  decoration: const InputDecoration(
                    labelText: "Ingrese apellido materno",
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                //const SizedBox(height: 20),
                //const Text('Telefono: '),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _telController,
                  decoration: const InputDecoration(
                    labelText: "Teléfono",
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                //const SizedBox(height: 20),
                //const Text('Correo Electronico: '),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(
                    labelText: "Ingrese su correo electrónico",
                    //suffixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    String? requiredValidation = validateRequired(value);
                    if (requiredValidation != null) {
                      return requiredValidation;
                    }
                    return validateEmail(value);
                  },
                ),
                //const SizedBox(height: 20),
                //const Text('Contraseña: '),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwController,
                  obscureText: !_passwordVisible, // Ocultar o mostrar la contraseña
                  decoration: InputDecoration(
                    labelText: 'Ingrese una contraseña',
                    hintMaxLines: 1,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    errorMaxLines: 3, // Permitir que el mensaje de error se muestre en múltiples líneas
                  ),
                  validator: validatePassword,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Debe tener entre 8 y 10 caracteres, una letra mayúscula, una letra minúscula y un número',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                      ),
                      onPressed: () {
                        print('Cancelar');
                        // Limpiar formulario
                        _nombreController.clear();
                        _correoController.clear();
                        _passwController.clear();
                        _telController.clear();
                        _apePController.clear();
                        _apeMController.clear();
                         // REDIRIGIR A INICIO DE SESION
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Inicio()));
                      },
                      child: const Text("Cancelar", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 20), // Espacio entre los botones
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String? errorMessage = await addUser();
                          if (errorMessage == null) {
                            // Éxito, muestra la ventana emergente de confirmación
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Registro Exitoso'),
                                  content: const Text('El usuario ha sido registrado exitosamente.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Cierra el cuadro diálogo
                                        // REDIRIGE A LA PANTALLA DE INICIO DE SESION
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Inicio()));
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Muestra el error en una ventana emergente
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error al registrar usuario'),
                                  content: Text(errorMessage),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      child: const Text("Registrarse", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}