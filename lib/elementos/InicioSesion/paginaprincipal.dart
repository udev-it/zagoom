import 'dart:convert';

import 'package:zagoom/elementos/InicioSesion/inicio.dart';
import 'package:zagoom/elementos/Consulta/consulta.dart';
import 'package:zagoom/elementos/elementos_vehiculo.dart';
import 'package:zagoom/elementos/ficha_vehicular.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

class PaginaPrincipal extends StatefulWidget{
  const PaginaPrincipal({super.key});
@override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
   int _processInsp = 0;
   int _idUser = 0;  //AGREGADO 29/05/2024
   int _statusLastAuto = 0;
   String _marca = '';
   String _modelo = '';
   int _contFts = 0;
   int sesionProcess = 0;
   String _noMotor = '';
   final List<String> _elementos = [];
   bool _loadsesion = false;

  @override
  void initState() {
    super.initState();
    ordenEjecucion();
  }

  Future<void> ordenEjecucion() async {
    await backupValues();
    await returnLastCar();
  }

  Future<void> returnLastCar() async {
    if(_processInsp == 0 && sesionProcess == 0){
      await detectInspectionBD();
      final url = Uri.parse('https://glorious-sparkle-development.up.railway.app/zagoom/inspeccion-vehicular/consulta-registro-vehicular?idUsuario=$_idUser&last=true');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if(_statusLastAuto == 0){
          _processInsp = 1;
          final responseData = jsonDecode(response.body);
          _modelo = responseData['carModelName'];
          _marca = responseData['carBrand'];
          _noMotor = responseData['noMotor'];
          List<dynamic> carInspectionRegistryDetails = responseData['carInspectionRegistryDetails'];
          _contFts = 0;
          for (var detail in carInspectionRegistryDetails) {
            _elementos.add(detail['descripcionElemento']);
            _contFts++;
          }
          _loadsesion = true;
        }else{
          _loadsesion = true;
          _processInsp = 0;
        }
      } else if(response.statusCode == 400){
        _loadsesion = true;
      }
    }
    setState(() {
      
    });
  }

  Future<void> detectInspectionBD() async {
  if (_processInsp == 0) {
    final conexion = await MySqlConnection.connect(ConnectionSettings(
      host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
      port: 3306,
      user: 'admin',
      password: '123456789',
      db: 'BDZAGOOM',
    ));
    try {
      Results status = await conexion.query('SELECT id_status FROM car_registry_aux WHERE user_id_fk = $_idUser ORDER BY car_registry_id DESC LIMIT 1');
      
      // Verifica si el resultado está vacío
      if (status.isEmpty) {
        _statusLastAuto = 1;
      } else {
        var row = status.first;
        _statusLastAuto = row['id_status'];
      }
     
      setState(() {
      });
    } catch (e) {
      // Maneja cualquier excepción que pueda ocurrir aquí
    } finally {
      conexion.close();
    }
  }
}


  Future<void> backupValues () async {
    final prefs = await SharedPreferences.getInstance();
    _processInsp = prefs.getInt('InspProcess') ?? 0;
    sesionProcess = prefs.getInt('sesionProcess') ?? 0;
    
    _idUser = prefs.getInt('idUser') ?? 0;  //AGREGADO 29/05/2024
    print('InspProcess: $_processInsp');
    print('sesionProcess: $sesionProcess');
    print('idUser: $_idUser');
    if(sesionProcess == 1){
      _loadsesion = true;
    }
    setState(() {
      
    });
  }

  Future<void> saveReturnCar () async {
    
    if(sesionProcess == 0){  
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('InspProcess', _processInsp); 
        prefs.setString('marca', _marca);
        prefs.setString('modelo', _modelo);
        prefs.setString('noMotor', _noMotor);
        prefs.setInt('contFts', _contFts); 
        prefs.setStringList('elementos', _elementos);
        print('marca: $_marca');
        print('InspProcess: $_processInsp');
        print('modelo: $_modelo');
        print('noMotor: $_noMotor');
        print('contFts: $_contFts');
        print('elementos: $_elementos');

    }
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
                onPressed:!_loadsesion ? null : () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Consulta()));
                },
                icon: const Icon(Icons.directions_car),
                label: const Text('Consultar Vehículos'),
              ),
              const SizedBox(height: 16), // espacio entre los  buttons
              ElevatedButton.icon(
                onPressed: !_loadsesion ? null : () async {
                  if(_processInsp == 1){
                    await saveReturnCar();
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const ElementosVehiculo()));
                  }else{
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const FichaVehicular()));
                  }
                },
                icon: const Icon(Icons.directions_car),
                label: const Text('Nueva Inspección Vehicular'),
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





  