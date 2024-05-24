//import 'package:app_zagoom/elementos/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart';

class ElementosVehiculo extends StatefulWidget {
  const ElementosVehiculo({super.key});

  @override
  State<ElementosVehiculo> createState() => _ElementosVehiculoState();
}

class _ElementosVehiculoState extends State<ElementosVehiculo> {
  
  String _marca = '';
  String _modelo = '';
  String _anio = '';
  String _color = '';
  String _noMotor = '';
  Icon _iconoActual = const Icon(Icons.minimize);
  late MySqlConnection conexion;
  int _idAutoF = 0;
  List<Elemento> elementos = [];

/*==============================FUNCIONES UTILIZADAS==============================*/

  @override
  void initState() {
    super.initState();
    conexionBD();
    guardadoFicha();
  }

  Future<void> guardadoFicha () async {
    final prefs = await SharedPreferences.getInstance();
    _marca = prefs.getString('marca') ?? '';
    _modelo = prefs.getString('modelo') ?? '';
    _anio = prefs.getString('anio') ?? '';
    _color = prefs.getString('color') ?? '';
    _noMotor = prefs.getString('noMotor') ?? '';
    
    setState(() {
      
    });
  }
  Future<void> conexionBD () async {
    conexion = await MySqlConnection.connect(ConnectionSettings(
      host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
      port: 3306,
      user: 'admin',
      password: '123456789',
      db: 'BDZAGOOM',
    ));
  }

  Future<void> BackupElements () async {
    Results autoBup = await conexion.query('SELECT idAuto FROM auto ORDER BY idAuto DESC LIMIT 1');
      if (autoBup.isNotEmpty) {
        // Obtiene el valor del idAuto de la primera fila
        var row = autoBup.first;
        _idAutoF = row['idAuto'];
        Results results = await conexion.query(
          '''SELECT idElemento, elemento FROM auto, imagen, elementos_Auto 
          WHERE auto.idAuto = ? AND auto.idAuto = imagen.idAuto AND idElemento = id_elemento''',
          [_idAutoF]
        );
          for (var row in results) {
          int idElemento = row['idElemento'];
          String elemento = row['elemento'];
          
          // Crea una instancia de Elemento y agrégala a la lista
          elementos.add(Elemento(idElemento: idElemento, elemento: elemento));
        }
      }
  }
  
  Future<void> agregarElementoBD(idAuto,idElemento/*,fotografia*/) async {
    try {   //despues agregar  la imagen 23-05-2024
        await conexion.query('''
          INSERT INTO imagen (idAuto, idElemento, estado)  
          VALUES (?, ?, ?)
        ''', [idAuto,idElemento, 1]);
      } catch (e) {
        print('Error al insertar datos: $e');
      } finally {
        await conexion.close();
    }
  }

  void _funtIconoActual(int idElemento) {
  // Ícono de archivo genérico
  }

  Future<void>  agregarElementoFt (idElemento/*,fotografia*/) async {

      
  }

  Future<void> agregarCarro() async {
    try {
        await conexion.query('''
          INSERT INTO auto (id_user,no_motor, marca, modelo, color, anio, id_status,modo_conduccion)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', [1, _noMotor, _marca, _modelo, _color, _anio, 1, 'estandar']);
      } catch (e) {
        print('Error al insertar datos: $e');
      } finally {
        await conexion.close();
    }
  }

  void  _miFuncionDeCamara (int idElemento){
    //SIGUIENTE SPRINT: FUNCION PARA TOMAR LA FOTOGRAFIA Y RECUPERARLA

  }

  
/*=========================FUN DE FUNCIONES UTILIZADAS==========================*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Inspección de elementos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 106, 106),
        leading: IconButton(
          onPressed: (){
            print("back");
            Navigator.pop(context);
            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
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
      child:  Column(
        children:[ 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "$_marca $_modelo",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                const TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Elemento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Comprobar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Estado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ]),
                _construirFila('Duplicado de llaves', 1),
                _construirFila('Radio', 2),
                _construirFila('Tapetes', 3),
                _construirFila('Tarjeta SD', 4),
                _construirFila('LLanta de refacción', 5),
                _construirFila('Llave "L"/Cruz', 6),
                _construirFila('Reflejante', 7),
                _construirFila('Kit de emergencia', 8),
                _construirFila('Birlo de seguridad', 9),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                ),
                onPressed: () {
                  agregarCarro();      
                },
                child: const Text('Finalizar', style: TextStyle(color: Colors.white)),
              ),
          ),]  
        ),
      )
    );
  }

  TableRow _construirFila(String elemento, int idElemento) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(elemento),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: (){
            _miFuncionDeCamara(idElemento);
           },
          child: const Icon(Icons.camera_alt),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 20.0,
          child: _iconoActual,
        ),
      ),
    ]);
  }
}

class Elemento {
  final int idElemento;
  final String elemento;

  Elemento({required this.idElemento, required this.elemento});
}