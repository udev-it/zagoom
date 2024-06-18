import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zagoom/elementos/InicioSesion/paginaprincipal.dart';
import 'package:zagoom/elementos/Consulta/detalles.dart'; // Asegúrate de importar la pantalla de detalles
import 'package:mysql1/mysql1.dart';

class Consulta extends StatefulWidget {
  const Consulta({super.key});

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  List<dynamic> vehicles = [];
  List<int> statusCar = [];
  int _idUser = 0;

  @override
  void initState() {
    super.initState();
    ordenEjecucion();
  }

  Future<void> ordenEjecucion() async {
    await recuperadoUsuario();
    await fetchVehicles();
  }

  Future<void> recuperadoUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getInt('idUser') ?? 0;
      print('Recuperado idUser: $_idUser');
    });
  }

  Future<void> fetchVehicles() async {
    final url = Uri.parse('https://glorious-sparkle-development.up.railway.app/zagoom/inspeccion-vehicular/consulta-registro-vehicular?idUsuario=$_idUser');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'idUsuario': _idUser,
          'last': 'true',
        }),
      );

      if (response.statusCode == 200) {
        statusCar = await returnStatusBD();
        setState(() {
          vehicles = json.decode(response.body); // Actualiza el estado con la lista de vehículos
        });
      } else {
        // Imprime más información sobre el error
        print('Failed to load vehicles: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Captura cualquier otro error que pueda ocurrir
      print('Error fetching vehicles: $e');
    }
  }

  Future<List<int>> returnStatusBD() async {
    final conexion = await MySqlConnection.connect(ConnectionSettings(
      host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
      port: 3306,
      user: 'admin',
      password: '123456789',
      db: 'BDZAGOOM',
    ));
    
    List<int> listaStatus = [];
    
    try {
      Results status = await conexion.query('SELECT id_status FROM car_registry_aux WHERE user_id_fk = $_idUser ORDER BY car_registry_id');
      
      // Convertir los resultados en una lista de enteros
      for (var row in status) {
        listaStatus.add(row[0]); // Asumiendo que id_status es el primer campo en los resultados
      }
      
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexion con BD')),
      );
    } finally {
      // Asegúrate de cerrar la conexión incluso si hay un error
      await conexion.close();
    }
    
    return listaStatus;
  }

  Future<void> saveReturnCar (int index, String marca, String modelo, String anio, String color, String noMotor, int status) async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('nombreC', 'Vehículo ${index + 1}');
        prefs.setString('marcaC', marca);
        prefs.setString('modeloC', modelo);
        prefs.setString('anioC', anio);
        prefs.setString('colorC', color);
        prefs.setString('noMotorC', noMotor);
        prefs.setInt('statusC', status);
    }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Consultar vehículos",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Consultar vehículos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color.fromARGB(255, 255, 106, 106),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const PaginaPrincipal()));
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (BuildContext context, int index) {
            var vehicle = vehicles[index];
            var statusC = statusCar[index];
            return ListTile(
              title: Text('Vehículo ${index + 1}'),
              onTap: () async {
                await saveReturnCar (index, vehicle['carBrand'], vehicle['carModelName'], vehicle['anio'], vehicle['color'], vehicle['noMotor'], statusC);
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => const Detalles()));
              },
            );
          },
        ),
      ),
    );
  }
}
