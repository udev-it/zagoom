import 'package:app_zagoom/elementos/elementos_vehiculo.dart';
import 'package:flutter/material.dart';

class FichaVehicular extends StatefulWidget {
  const FichaVehicular({super.key});

  @override
  State<FichaVehicular> createState() => _PageHomeState();
}

class _PageHomeState extends State<FichaVehicular> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idMarca = TextEditingController();
  TextEditingController idModelo = TextEditingController();
  TextEditingController idAnio = TextEditingController();
  TextEditingController idColor = TextEditingController();
  TextEditingController idNoMotor = TextEditingController();

  /*==============================FUNCIONES UTILIZADAS==============================*/
String? validateAnio(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo es obligatorio';
    }
    if (value.length != 4 || int.tryParse(value) == null) {
      return 'Ingrese un año válido (4 dígitos)';
    }
    return null;
  }

  String? validateNoMotor(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo es obligatorio';
    }
    if (int.tryParse(value) == null) {
      return 'Ingrese un valor numérico válido';
    }
    return null;
  }

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
    /*=========================FUN DE FUNCIONES UTILIZADAS==========================*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ficha vehícular", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
        leading: IconButton(
          onPressed: (){
            print("back");
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: (){
              print("info");
            },
            icon: const Icon(Icons.help_outline, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(
                  child: Text('Ingrese los datos del vehículo',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: idMarca,
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: idModelo,
                  decoration: const InputDecoration(
                    labelText: 'Modelo',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: idAnio,
                  decoration: const InputDecoration(
                    labelText: 'Año',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateAnio,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: idColor,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: idNoMotor,
                  decoration: const InputDecoration(
                    labelText: 'No. de Motor',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateNoMotor,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Los campos son válidos, puedes continuar
                      print(idMarca.text);
                      print(idModelo.text);
                      print(idAnio.text);
                      print(idColor.text);
                      print(idNoMotor.text);
                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ElementosVehiculo()));
                    }
                  },
                  child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}