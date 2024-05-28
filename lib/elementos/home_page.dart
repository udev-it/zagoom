import 'package:app_zagoom/elementos/elementos_vehiculo.dart';
import 'package:app_zagoom/elementos/ficha_vehicular.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          title: const Text("Bienvenido a Zagoom"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 106, 106),
            ),
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
            child: const Text('Realizar inspección Vehicular', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}