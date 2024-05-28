import 'package:app_zagoom/elementos/elementos_vehiculo.dart';
import 'package:app_zagoom/elementos/ficha_vehicular.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginaPrincipal extends StatefulWidget{
  const PaginaPrincipal({super.key});
@override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
   int _processInsp = 0;

  @override
  void initState() {
    super.initState();
    procesoInspeccionBand ();
  }

  Future<void> procesoInspeccionBand () async {
    final prefs = await SharedPreferences.getInstance();
    _processInsp = prefs.getInt('InspProcess') ?? 0;
    print('LLEGAMOS A PROCESO INSP BAND');
    print(_processInsp);
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
       /* leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),*/
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
                 if(_processInsp == 1){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const ElementosVehiculo()));
                print("INICIO -> ELEMENTOS");
              }else{
                print("INICIO -> FICHAAA");
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const FichaVehicular()));
              }
              print(_processInsp);
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





  