import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:zagoom/elementos/InicioSesion/inicio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zagoom/elementos/recuperacion/ingresar_token.dart';

class PasswordChange extends StatefulWidget {
  final String correo;
  final String token;
  final int id;

  const PasswordChange({super.key, required this.correo, required this.token, required this.id});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final newPassword= TextEditingController();


 Future<bool> changePassBD () async {
    final conexion = await MySqlConnection.connect(ConnectionSettings(
      host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
      port: 3306,
      user: 'admin',
      password: '123456789',
      db: 'BDZAGOOM',
    ));

    try {
      Results status = await conexion.query('''
        UPDATE usuario 
        INNER JOIN email_recovery_token ON usuario.id_user = email_recovery_token.id_usuario
        SET usuario.password = ?
        WHERE usuario.correo = ? 
          AND usuario.id_user = ?
          AND email_recovery_token.tokenS = ?
      ''', [newPassword.text, widget.correo, widget.id, int.parse(widget.token)]);
      
      conexion.close();
      return status.affectedRows! > 0; // Devuelve true si se actualizó al menos una fila.
    } catch (e) {
      conexion.close();
      return false; // Devuelve false si hubo un error en la consulta.
    }
  }

/*
  Future<void> changePass(String toEmail, int tokenUser, int id, int newPassword) async {
    const String apiUrl = '';
    final Map<String, dynamic> data = {
      'correo': toEmail,
      'token': tokenUser,
      'id': id,
      'newPasswor':newPassword
    };
    try{
      final response = await http.post(
        Uri.parse(apiUrl), 
        headers: {'Content-Type': 'application/json'}, 
        body: json.encode(data), 
      );
      //print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      final message = response.body; 
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final int userId = responseData['id'];
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>const Inicio()));
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
  */

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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => IngresarToken(correo: widget.correo)));
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
                    'Ingresar nueva contraseña.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),/*
                  const Text(
                    'Ingresar su correo que está asociado con su cuenta de ZAGOOM.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),*/
                  const SizedBox(height: 20),
                  TextField(
                    controller: newPassword,
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
                      labelText: 'Nueva contraseña',
                      labelStyle: TextStyle(color: Colors.blue),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async{
                      bool checkChange = await changePassBD ();
                      if(checkChange){
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('cambio de contraseña exitosa')));
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Inicio()));
                      }else{
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al cambiar contraseña, intente de nuevo')));
                      }
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