import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:zagoom/pantallas/password_change.dart';

class IngresarToken extends StatefulWidget {
  final String correo;
  const IngresarToken({super.key, required this.correo});

  @override
  State<IngresarToken> createState() => _IngresarTokenState();
}

class _IngresarTokenState extends State<IngresarToken> {
  final token = TextEditingController();

  Future<void> validateToken(String toEmail, int tokenUser) async {
    const String apiUrl = 'https://glorious-sparkle-development.up.railway.app/zagoom/user/validate-token';
    final Map<String, dynamic> data = {
      'correo': toEmail,
      'token': tokenUser,
    };
    try{
      final response = await http.post(
        Uri.parse(apiUrl), 
        headers: {'Content-Type': 'application/json'}, 
        body: json.encode(data), 
      );
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      final message = response.body; 
      if (response.statusCode == 200) {
        //final Map<String, dynamic> responseData = json.decode(response.body);
        //final int userId = responseData['id'];
        const int userId = 0;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PasswordChange(correo: toEmail, token: tokenUser.toString(), id:userId)));
        }
      } else{
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (e){
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ZAGOOM",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Ingresar el código.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ingresar el código enviado por su correo. ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: token,
                    cursorColor: Colors.blue,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: 'Código de 1 a 4 digitos',
                      labelStyle: TextStyle(color: Colors.blue),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async{
                      int tokenUser = int.parse(token.text);
                      validateToken(widget.correo, tokenUser);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}