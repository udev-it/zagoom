import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

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

  Future<bool> addUser() async {
    bool success = false;
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
      port: 3306,
      user: 'admin',
      password: '123456789',
      db: 'BDZAGOOM',
    ));

    try {
      await conn.query('''
          INSERT INTO usuario (nombre, apellidoP, apellidoM, telefono, correo, password)
          VALUES (?, ?, ?, ?, ?, ?)
        ''', [_nombreController.text, _apePController.text, _apeMController.text, _telController.text, _correoController.text, _passwController.text, ]);
      success = true;
    } catch (e) {
      print('Error al insertar datos: $e');
    } finally {
      await conn.close();
    }
    return success;
  }

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
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
                  validator: validateRequired,
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
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: validateRequired,
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
                          if (await addUser()) {
                            // ignore: use_build_context_synchronously
                            //REDIRIGE A LA PANTALLA DE INICIO DE SESION
                            //CHECAR NOMBRE DE PANTALLA
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Inicio()));
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