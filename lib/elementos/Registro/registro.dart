import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final RegExp contra = RegExp(r'^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])\S{8,}$'); // contraseña

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
    if (!contra.hasMatch(value ?? '')) {
      return 'Debe tener al menos 8 caracteres, una letra mayúscula y un número';
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
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                print("info");
              },
              icon: const Icon(Icons.help_outline, color: Colors.white),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                SizedBox(
                  child: Image.asset('assets/adduser.png', width: 100, height: 100),
                ),
                const SizedBox(height: 20),
                const Text('Usuario: '),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese su(s) nombre(s)',
                    suffixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _apePController,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese apellido paterno',
                    suffixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _apeMController,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese apellido materno',
                    suffixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 20),
                const Text('Telefono: '),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _telController,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese su número telefónico ',
                    suffixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 20),
                const Text('Correo Electronico: '),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese su email ',
                    suffixIcon: Icon(Icons.email_outlined),
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
                const SizedBox(height: 20),
                const Text('Contraseña: '),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwController,
                  obscureText: !_passwordVisible, // Ocultar o mostrar la contraseña
                  decoration: InputDecoration(
                    hintText: '*******',
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
                  validator: (value) {
                    String? requiredValidation = validateRequired(value);
                    if (requiredValidation != null) {
                      return requiredValidation;
                    }
                    return validatePassword(value);
                  },
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
                                          //Cambiar el nombre de HomePage
                                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
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