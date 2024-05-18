import 'package:app_zagoom/elementos/ficha_vehicular.dart';
import 'package:flutter/material.dart';

class ElementosVehiculo extends StatefulWidget {
  const ElementosVehiculo({super.key});

  @override
  State<ElementosVehiculo> createState() => _ElementosVehiculoState();
}

class _ElementosVehiculoState extends State<ElementosVehiculo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Inspección de elementos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const FichaVehicular()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: (){
              print("info");
            },
            icon: const Icon(Icons.help_outline, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
      child:  Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text('Elementos', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              //Elemento 1
              const Text("Duplicado de llaves", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

              //Elemento 2
              const SizedBox(height: 20),
              const Text("Radio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

              //Elemento 3
              const SizedBox(height: 20),
              const Text("Tapetes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

              //Elemento 4
              const SizedBox(height: 20),
              const Text("Tarjeta SD", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

              //Elemento 5
              const SizedBox(height: 20),
              const Text("Llanta de refacción", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

              //Elemento 6
              const SizedBox(height: 20),
              const Text("Reflejante", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

              //Elemento 7
              const SizedBox(height: 20),
              const Text("Kit de emergencia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

              //Elemento 8
              const SizedBox(height: 20),
              const Text("Birlo de seguridad", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

              //Elemento 9
              const SizedBox(height: 20),
              const Text("Otros", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("Si", style: TextStyle(color: Colors.black))
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                    ),
                    onPressed: () {},
                    child: const Text("No", style: TextStyle(color: Colors.black))
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}