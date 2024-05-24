import 'package:flutter/material.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Handle "Consultar Vehiculos" button press
                },
                icon: const Icon(Icons.directions_car),
                label: const Text('Consultar Vehiculos'),
              ),
              const SizedBox(height: 16), // espacio entre los  buttons
              ElevatedButton.icon(
                onPressed: () {
                  
                },
                icon: const Icon(Icons.directions_car),
                label: const Text('Nueva Inspeccion Vehicular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
