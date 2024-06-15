//import 'package:app_zagoom/elementos/home_page.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart';
import 'package:zagoom/elementos/InicioSesion/paginaprincipal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';


class ElementosVehiculo extends StatefulWidget {
  const ElementosVehiculo({super.key});

  @override
  State<ElementosVehiculo> createState() => _ElementosVehiculoState();
}

class _ElementosVehiculoState extends State<ElementosVehiculo> {
  
  String _marca = '';
  String _modelo = '';
  int _processInsp = 0;
  final List<Icon> _iconoActual = [const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize),const Icon(Icons.minimize), const Icon(Icons.minimize)];
  final List<Icon> _iconoActualCm = [const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt),const Icon(Icons.camera_alt), const Icon(Icons.camera_alt)];
  final List<bool> _ableCamara = [true, true, true,true, true, true,true, true, true];
  int _idAutoF = 0;
  List<int> ideElementos = []; 
  List<String> ftElementos = []; //CHECAR SI PUEDE SEGUIR SIENDO STRING - ULTIMA REVISION: 27/05/2024
  bool _botonDeshabilitado = false;
  int _contFts = 0;
  int _idUser = 0; //AGREGADO 29/05/2024
  File? imagen; //AGREGADO 05/06/2024
/*==============================FUNCIONES UTILIZADAS==============================*/

  @override
  void initState() {
    super.initState();
    ordenEjecucion();
    
    
  }

  Future<void> ordenEjecucion() async {
    await recuperadoFicha();
    await _cargaBackupVehuculo();
  }

//FUNCION PARA LA RECUPERACION DE LOS DATOS DE LA FICHA TECNICA DEL VEHICULO (SHARED_PREFERENCES -> RECUPERACION DE DATOS)
  Future<void> recuperadoFicha () async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _marca = prefs.getString('marca') ?? '';
      _modelo = prefs.getString('modelo') ?? '';
      _processInsp = prefs.getInt('InspProcess') ?? 0;
      _contFts = prefs.getInt('contFts') ?? 0;
      _idUser = prefs.getInt('idUser') ?? 0;  //AGREGADO 29/05/2024
    });
  }

//FUNCION PARALA RECUPERACION DE LA ID DE LOS ELEMENTOS (SHARED_PREFERENCES)
  Future<List<int>> cargarIdsElemento() async {
    final prefs = await SharedPreferences.getInstance();
    final elementosGuardados = prefs.getStringList('elementos') ?? [];

    final idsElemento = elementosGuardados.map((elementoString) {
      final partes = elementoString.split('|');
      return int.parse(partes[0]);
    }).toList();

    return idsElemento;
  }

//FUNCION PARA LA RECUPERACION DE LA FOTOGRAFIA DE LOS ELEMENTOS (SHARED_PREFERENCES) %%% CHECAR  VARIABLE DE RECUPERACION
  Future<List<String>> cargarFotografia() async {
    final prefs = await SharedPreferences.getInstance();
    final elementosGuardados = prefs.getStringList('elementos') ?? [];

    final fotografia = elementosGuardados.map((elementoString) {
      final partes = elementoString.split('|');
      return partes[1];
    }).toList();

    return fotografia;
  }

//FUNCION PARA LA CARGA DEL BACKUP RECUPERADO DE LAS DEMAS FUNCIONES
  Future<void> _cargaBackupVehuculo () async {
      print('LLEGAMOS A LA FUNCION DE RECUPERAR ELEMENTOS');
      ideElementos = await cargarIdsElemento();
      ftElementos = await cargarFotografia();

      if (ideElementos.isNotEmpty) {
        print("entre 1.1  SP");
        for(int i = 0; i < 9; i++){
          int indice = ideElementos.indexWhere((element) => element == i);
          if(indice != -1){
            print("entre 1.1.1 SP");
            _iconoActual[i] = const Icon(Icons.check);
            _ableCamara[i] = false;
            _iconoActualCm[i] = const Icon(Icons.camera_alt, color: Colors.grey);
          }
        }
        if(_contFts == 9){
          _botonDeshabilitado = true;
        }
      }
  }

//FUNCION PARA CAMBIAR EL ICONO CUANDO ESTE DEBE SER ACTUALIZADO UNA VEZ LA CAMARA TOMO LA FOTO Y FUE GUARDADA
  void _funtIconChange(int idElementoActual) {
    _iconoActual[idElementoActual] = const Icon(Icons.check);
    _iconoActualCm[idElementoActual] = const Icon(Icons.camera_alt, color: Colors.grey);
    _ableCamara[idElementoActual] = false;
    setState(() {
       
    });
  }

//GUARDAR EL CONTADOR DE LOS ELEMENTOS GUARDADOS (SHARED_PREFERENCES)
  Future<void> guardadoElementCont () async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('contFts', _contFts); 
  }

//FUNCION PARA GUARDAR LOS ELEMENTOS CAPTURADOS DE MANERA PROVISIONAL (SHARED_PREFERENCES)
  Future<void> _guardadoElementosSP (int idElemento,/*,fotografia*/) async {

    String foto = 'esto sera una cadena de foto';
    final elementoString = '$idElemento|$foto'; // Combina los valores
    final prefs = await SharedPreferences.getInstance();
    final elementosGuardados = prefs.getStringList('elementos') ?? [];
    elementosGuardados.add(elementoString);
    await prefs.setStringList('elementos', elementosGuardados);
  }

//FUNCIONALIDAD COMPLETA DE LA CAMARA PARA TOMAR LA FOTO Y GUARDARLA (SHARED_PREFERENCES)
  Future<void> _miFuncionDeCamara (int idElemento) async{
    // INICIO DE LA FUNCIONALIDAD DE LA CAMARA
    XFile? imgRuta;

    imgRuta = await ImagePicker().pickImage(source: ImageSource.camera);
    
    setState(() {
      if (imgRuta != null) {
        imagen = File(imgRuta.path);

        _guardadoElementosSP(idElemento/*,fotografia*/);
        _funtIconChange(idElemento);
        _contFts++;
        guardadoElementCont();
        if(_contFts == 9){
          _botonDeshabilitado = true;
        }
        
      } else {
        imagen = File('');
      }
    });

  }

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCIONES RELACIONADAS CON LA BASE DE DATOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
//FUNCION PARA AGREGAR LOS ELEMENTOS DEL VEHICULO A  LA BASE DE DATOS  (FUNCION DE BASE DE DATOS)
  Future<void> agregarElementoBD(List<int> idElemento/*,fotografia*/) async {
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
        for(int i = 0; i < idElemento.length; i++){
          await conexion.query('''
            INSERT INTO imagen (idAuto, idElemento, estado)  
            VALUES (?, ?, ?)
          ''', [_idAutoF,idElemento[i], 1]);
        }
      
    } catch (e) {
    }
    conexion.close();
  }


//FUNCION PARA GUARDAR TODO LO GUARDADO EN SHARED_PREFERENCES A LA BASE DE DATOS
  Future<void> guardarBD () async {
    ideElementos = await cargarIdsElemento();
    ftElementos = await cargarFotografia();
    setState(() {
      _botonDeshabilitado  = false ; 
    });
    await agregarElementoBD(ideElementos);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIN DE LAS FUNCIONES RELACIONADAS CON LA BASE DE DATOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const PaginaPrincipal()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        /*actions: [
          IconButton(
            onPressed: (){
              print("info");
            },
            icon: const Icon(Icons.help_outline, color: Colors.white),
          )
        ],*/
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
              onPressed: !_botonDeshabilitado ? null : () async {
                await guardarBD ();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const PaginaPrincipal()));
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
          onTap: !_ableCamara[idElemento] ? null : (){
            _miFuncionDeCamara(idElemento);
           },
          child: _iconoActualCm[idElemento],
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