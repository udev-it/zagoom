import 'package:flutter/material.dart';
import 'package:zagoom/elementos/Consulta/consulta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detalles extends StatefulWidget {
  const Detalles({super.key,});

  @override
  State<Detalles> createState() => _DetallesState();
}

class _DetallesState extends State<Detalles> {
  String nombre = '';
  String marca = '';
  String modelo = '';
  String ano = '';
  String color = '';
  String numeroMotor = '';
  int status = 0;

  @override
  void initState() {
    super.initState();
    ordenEjecucion();    
    
  }

  Future<void> ordenEjecucion() async {
    await backupValues();
  }

  Future<void> backupValues () async {
    final prefs = await SharedPreferences.getInstance();
    nombre = prefs.getString('nombreC') ?? '';
    marca = prefs.getString('marcaC') ?? '';
    modelo = prefs.getString('modeloC') ?? '';
    ano = prefs.getString('anioC') ?? '';
    color = prefs.getString('colorC') ?? '';
    numeroMotor = prefs.getString('noMotorC') ?? '';
    status = prefs.getInt('statusC') ?? 0;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Consulta de vehículos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
        leading: IconButton(
          onPressed: () {
            print("back");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Consulta()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text(nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Marca'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(marca),
                  ),
                ]),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Modelo'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(modelo),
                  ),
                ]),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Año'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ano),
                  ),
                ]),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Color'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(color),
                  ),
                ]),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No. de motor'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(numeroMotor),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 24),
            const Center(child: Text('Status de inspección', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            Center(child: Text(status == 1 ? 'Finalizado' : 'En Curso', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                ),
                child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Consulta()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
