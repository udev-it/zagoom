import 'package:zagoom/elementos/InicioSesion/inicio.dart';
import 'package:zagoom/elementos/elementos_vehiculo.dart';
import 'package:zagoom/elementos/ficha_vehicular.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginaPrincipal extends StatefulWidget{
  const PaginaPrincipal({super.key});
@override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
   int _processInsp = 0;
   int _idUser = 0;  //AGREGADO 29/05/2024

  @override
  void initState() {
    super.initState();
    procesoInspeccionBand ();
  }

  Future<void> procesoInspeccionBand () async {
    final prefs = await SharedPreferences.getInstance();
    _processInsp = prefs.getInt('InspProcess') ?? 0;
    _idUser = prefs.getInt('idUser') ?? 0;  //AGREGADO 29/05/2024
    print('LLEGAMOS A PROCESO INSP BAND y ID');  //AGREGADO 29/05/2024
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
                  print('DATOS');   //AGREGADO 29/05/2024
                  print(_idUser);   //AGREGADO 29/05/2024
                  print(_processInsp);   //AGREGADO 29/05/2024
                  if(_processInsp == 1){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const ElementosVehiculo()));
                    print("INICIO -> ELEMENTOS");
                  }else{
                    print("INICIO -> FICHAAA");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const FichaVehicular()));
                  }
                },
                icon: const Icon(Icons.directions_car),
                label: const Text('Nueva Inspeccion Vehicular'),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Inicio()));
                },
                icon: const Icon(Icons.close_outlined),
                label: const Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





  