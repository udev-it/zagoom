//import 'package:app_zagoom/elementos/ficha_vehicular.dart';
import 'package:flutter/material.dart';
import 'package:zagoom/elementos/InicioSesion/inicio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zagoom/elementos/InicioSesion/paginaprincipal.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _idUser = 0;

  @override
  void initState() {
      super.initState();      
      recuperadoFicha ();
    }

  Future<void> recuperadoFicha () async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getInt('idUser') ?? 0;  //AGREGADO 29/05/2024
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _idUser == 0 ? const Inicio() : const PaginaPrincipal(),
    );
  }
}