import 'package:app_zagoom/elementos/InicioSesion/paginaprincipal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

//import 'package:mysql1/mysql1.dart';

class Inicio extends StatefulWidget{
  const Inicio({super.key});
  @override
  State<Inicio> createState()=>_InicioState();
}

class _InicioState  extends State<Inicio>{
 final TextEditingController _correoTelefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
 final RegExp reMedio = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
 final RegExp contra=RegExp(r'^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])\S{8}$');
 

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
        backgroundColor: const Color.fromARGB(255, 255, 106,106),
      ),
      body: SingleChildScrollView(
       child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            const Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Center(
              
              child: Text('Correo',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            ),
            ],
            ),
             Row(//correo/telefono
          children: [
            const SizedBox(width: 10),
            Expanded(
              
              child: TextField(
                controller: _correoTelefonoController,
            decoration: const InputDecoration(
              //hintText: 'correo/telefono',
              border: OutlineInputBorder(),
            ),
            )
            ),
          ],
            ),
             const SizedBox(height: 15),
             const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text('Contraseña',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  
                ),
              ],
             ),
              Row(
              children: [
                 const SizedBox(width: 10),                             //para ingresar a la pagina principal usar la contraseña ingresar mayusculas y numeros
                 Expanded(
                  child: TextField(
                     controller: _contrasenaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                  
                  )
              ],
             ),
             const SizedBox(height: 15),
             TextButton(
                onPressed: () {},
                child: const Text('¿Olvidaste tu contraseña?'),
              ),

               const SizedBox(height: 25),
              
              ElevatedButton(
              
                onPressed:() {
                
                  if (reMedio.hasMatch(_correoTelefonoController.text)&& contra.hasMatch(_contrasenaController.text)){
                    
                    Navigator.push(context,MaterialPageRoute(builder: (BuildContext contex)=> const PaginaPrincipal()));
                   /// print('hola');
                   }

               // print('hola');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red, // Esto cambiará el color del texto a blanco
                ),
                child: const Text('Iniciar sesión',style: TextStyle(fontSize: 15)),
              ),
                const SizedBox(height: 30),
                const Divider(color: Color.fromRGBO(0, 0, 0, 1)), // Esto dibujará una línea
                const SizedBox(height:30),
              Column(
           mainAxisAlignment: MainAxisAlignment.center, // Alinea los botones en el centro
         children: [
    SignInButton(
      Buttons.Google,
      onPressed: () {},
    ),
    const SizedBox(height: 20),
    SignInButton(
      Buttons.Facebook,
      onPressed: () {},
    ),
  ],
),
                const SizedBox(height: 25),
              TextButton(
                onPressed: () {},
                child: const Text('No tienes una cuenta? Crea una'),
              ),
          ],
        ),
      
      ),
      ),
    );
  }

}
