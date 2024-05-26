//import 'package:app_zagoom/elementos/home_page.dart';
import 'package:app_zagoom/elementos/home_page.dart';
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
  int _processInsp = 0;
  final List<Icon> _iconoActual = [const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize),const Icon(Icons.minimize), const Icon(Icons.minimize)];
  int _idAutoF = 0;
  List<int> ideElementos = [];
  final bool _botonDeshabilitado = false;
  int _contFts = 0;

/*==============================FUNCIONES UTILIZADAS==============================*/

  @override
  void initState() {
    super.initState();
    ordenEjecucion();
    
    
  }

  Future<void> ordenEjecucion() async {
    await recuperadoFicha();
    await agregarCarro(); 
    await backupElements();
  }

//FUNCION PARA LA RECUPERACION DE LOS DATOS DE LA FICHA TECNICA DEL VEHICULO
  Future<void> recuperadoFicha () async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _marca = prefs.getString('marca') ?? '';
      _modelo = prefs.getString('modelo') ?? '';
      _anio = prefs.getString('anio') ?? '';
      _color = prefs.getString('color') ?? '';
      _noMotor = prefs.getString('noMotor') ?? '';
      _processInsp = prefs.getInt('InspProcess') ?? 0;
    });
    print("SIIIII");
    print(_processInsp);
  }

  Future<void> guardadoFicha () async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('contFts', _contFts); 
  }

//FUNCION PARA RECUPERAR LA INFORMACION DE LOS ELEMENTOS PREGUARDADOS
  Future<void> backupElements () async {
    if(_processInsp == 1){
      print("SE CUMPLEEEE");
      final conexion = await MySqlConnection.connect(ConnectionSettings(
        host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
        port: 3306,
        user: 'admin',
        password: '123456789',
        db: 'BDZAGOOM',
      ));
      Results autoBup = await conexion.query('SELECT idAuto,marca,modelo FROM auto ORDER BY idAuto DESC LIMIT 1');
        if (autoBup.isNotEmpty) {
          print("entre 1");
          // Obtiene el valor del idAuto de la primera fila
          var row = autoBup.first;
          _idAutoF = row['idAuto'];
          _marca = row['marca'];
          _modelo = row['modelo'];
          Results results = await conexion.query(
            '''SELECT idElemento FROM auto, imagen
            WHERE auto.idAuto = ? AND auto.idAuto = imagen.idAuto''',
            [_idAutoF]
          );
          if (results.isNotEmpty) {
            print("entre 1.1");
            for (var row in results) {
              ideElementos.add(row['idElemento']);
            }
            for(int i = 1; i <= 9; i++){
              int indice = ideElementos.indexWhere((element) => element == i);
              if(indice != -1){
                print("entre 1.1.1");
                _iconoActual[i-1] = const Icon(Icons.check);
              }
            }
          }
        }
      conexion.close();
    }
    setState(() {
        
    });
  }
  
//FUNCION PARA AGREGAR LOS ELEMENTOS DEL VEHICULO A  LA BASE DE DATOS
  Future<void> agregarElementoBD(int idElemento/*,fotografia*/) async {
    final conexion = await MySqlConnection.connect(ConnectionSettings(
      host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
      port: 3306,
      user: 'admin',
      password: '123456789',
      db: 'BDZAGOOM',
    ));
    try {
      Results autoBup = await conexion.query('SELECT idAuto FROM auto ORDER BY idAuto DESC LIMIT 1');
       var row = autoBup.first;
        _idAutoF = row['idAuto'];
      await conexion.query('''
        INSERT INTO imagen (idAuto, idElemento, estado)  
        VALUES (?, ?, ?)
      ''', [_idAutoF,idElemento+1, 1]);
    } catch (e) {
      print('Error al insertar datos: $e');
    }
    conexion.close();
  }
//FUNCION PARA CAMBIAR EL ICONO CUANDO ESTE DEBE SER ACTUALIZADO UNA VEZ LA CAMARA TOMO LA FOTO Y FUE GUARDADA
  void _funtIconChange(int idElementoActual) {
     _iconoActual[idElementoActual] = const Icon(Icons.check);
     setState(() {
       
     });
  }

  Future<void>  agregarElementoFt (idElemento/*,fotografia*/) async {
      
  }

  Future<void> agregarCarro() async {
    if(_processInsp != 1){
      print("se cumplio :D");
      final conexion = await MySqlConnection.connect(ConnectionSettings(
        host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
        port: 3306,
        user: 'admin',
        password: '123456789',
        db: 'BDZAGOOM',
      ));
      try {
          await conexion.query('''
            INSERT INTO auto (id_user,no_motor, marca, modelo, color, anio, id_status)
            VALUES (?, ?, ?, ?, ?, ?, ?)
          ''', [1, _noMotor, _marca, _modelo, _color, _anio, 1]);
        } catch (e) {
          print('Error al insertar datos: $e');
        } finally {
          await conexion.close();
      }
      conexion.close();
    }
  }

  void  _miFuncionDeCamara (int idElemento){
    //SIGUIENTE SPRINT: FUNCION PARA TOMAR LA FOTOGRAFIA Y RECUPERARLA
    agregarElementoBD(idElemento/*,fotografia*/);
    _funtIconChange(idElemento);
    _contFts++;
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
            if(_processInsp  == 1){
              print("ELEMENTOS -> INICIO");
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
            }else{
              Navigator.pop(context);
            }
            print("ELEMENTOS -> INICIO 2");
            print(_marca);
            print(_modelo);
            print(_anio);
            print(_color);
            print(_noMotor);
            print(_processInsp);
            
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
                _construirFila('Duplicado de llaves', 0),
                _construirFila('Radio', 1),
                _construirFila('Tapetes', 2),
                _construirFila('Tarjeta SD', 3),
                _construirFila('LLanta de refacción', 4),
                _construirFila('Llave "L"/Cruz', 5),
                _construirFila('Reflejante', 6),
                _construirFila('Kit de emergencia', 7),
                _construirFila('Birlo de seguridad', 8),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _botonDeshabilitado ? const Color.fromARGB(255, 255, 106, 106) : Colors.grey,
              ),
              onPressed: !_botonDeshabilitado ? null : () {
                print('Finalización');
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
          child: _iconoActual[idElemento],
        ),
      ),
    ]);
  }
}
