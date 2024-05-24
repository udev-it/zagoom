import 'package:app_zagoom/elementos/ficha_vehicular.dart';
import 'package:flutter/material.dart'; 

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
//hola nueva version
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FichaVehicular(),
    );
  }
}