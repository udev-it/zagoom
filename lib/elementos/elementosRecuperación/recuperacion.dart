import 'package:flutter/material.dart';

class RecuperarPantalla extends StatefulWidget {
  const RecuperarPantalla({super.key});

  @override
  State<RecuperarPantalla> createState() => _RecuperarPantallaState();
}

class _RecuperarPantallaState extends State<RecuperarPantalla> {
  final _correo = TextEditingController();

@override
  void initState() {
    super.initState();
    //resetearContra(); 
  }  

  @override
  void dispose() {
    _correo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ZAGOOM",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
        leading: IconButton(
          onPressed: () {
            print("back");
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Recuperación de Contraseña',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ingresar su correo que está asociado con su cuenta de ZAGOOM.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _correo,
                    cursorColor: Colors.blue,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: 'Correo',
                      labelStyle: TextStyle(color: Colors.blue),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (){
                      //resetearContra();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}