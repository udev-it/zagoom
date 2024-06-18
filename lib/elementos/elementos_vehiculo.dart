//import 'package:app_zagoom/elementos/home_page.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart';
import 'package:zagoom/elementos/InicioSesion/paginaprincipal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:async';




class ElementosVehiculo extends StatefulWidget {
  const ElementosVehiculo({super.key});

  @override
  State<ElementosVehiculo> createState() => _ElementosVehiculoState();
}

class _ElementosVehiculoState extends State<ElementosVehiculo> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String _marca = '';
  String _modelo = '';
  int _processInsp = 0;
  final List<Icon> _iconoActual = [const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize), const Icon(Icons.minimize),const Icon(Icons.minimize), const Icon(Icons.minimize)];
  final List<Icon> _iconoActualCm = [const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt), const Icon(Icons.camera_alt),const Icon(Icons.camera_alt), const Icon(Icons.camera_alt)];
  final List<bool> _ableCamara = [true, true, true,true, true, true,true, true, true];
  final List<String> elementsValues = ['Duplicado de llaves','Radio','Tapetes','Tarjeta SD','Llanta de refaccion','Llave "L"/Cruz','Reflejante','Kit de emergencia','Birlo de seguridad'];
  String _noMotor = '';
  List<String> nameElementos = [];
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
    await returnValues();
    await _cargaBackupVehuculo();
  }

//FUNCION PARA LA RECUPERACION DE LOS DATOS DE LA FICHA TECNICA DEL VEHICULO (SHARED_PREFERENCES -> RECUPERACION DE DATOS)
  Future<void> returnValues () async {
    final prefs = await SharedPreferences.getInstance();
      
    setState(() {
      _marca = prefs.getString('marca') ?? '';
      _modelo = prefs.getString('modelo') ?? '';
      _processInsp = prefs.getInt('InspProcess') ?? 0;
      _contFts = prefs.getInt('contFts') ?? 0;
      _idUser = prefs.getInt('idUser') ?? 0;//AGREGADO 29/05/2024
      nameElementos = prefs.getStringList('elementos') ?? [];
      _noMotor = prefs.getString('noMotor') ?? '';
    });
  }

  Future<void> saveReturnCar () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('contFts', _contFts);
        prefs.setInt('sesionProcess', 1);

    }

//FUNCION PARALA RECUPERACION DE LA ID DE LOS ELEMENTOS (SHARED_PREFERENCES)

//FUNCION PARA LA CARGA DEL BACKUP RECUPERADO DE LAS DEMAS FUNCIONES
  Future<void> _cargaBackupVehuculo () async {
    if(_processInsp == 1){
      if (nameElementos.isNotEmpty) {
        for(int i = 0; i < 9; i++){
          int indice = nameElementos.indexWhere((element) => element == elementsValues[i]);
          if(indice != -1){
            _funtIconChange(i);
          }
        }
        if(_contFts == 9){
          _botonDeshabilitado = true;
        }
      }
    }   
  }

//FUNCION PARA CAMBIAR EL ICONO CUANDO ESTE DEBE SER ACTUALIZADO UNA VEZ LA CAMARA TOMO LA FOTO Y FUE GUARDADA
  void _funtIconChange(int idElementoActual) {
    setState(() {
      _iconoActual[idElementoActual] = const Icon(Icons.check);
      _iconoActualCm[idElementoActual] = const Icon(Icons.camera_alt, color: Colors.grey);
      _ableCamara[idElementoActual] = false;
    });
    
  }

//GUARDAR EL CONTADOR DE LOS ELEMENTOS GUARDADOS (SHARED_PREFERENCES)
  Future<void> guardadoElementCont () async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('contFts', _contFts); 
  }

//FUNCION PARA GUARDAR LOS ELEMENTOS CAPTURADOS DE MANERA PROVISIONAL (SHARED_PREFERENCES)
  Future<void> _guardadoElementosSP (String nameElemento) async {

    final prefs = await SharedPreferences.getInstance();
    final elementosGuardados = prefs.getStringList('elementos') ?? [];
    elementosGuardados.add(nameElemento);
    await prefs.setStringList('elementos', elementosGuardados);
  }

  Future<void> _miFuncionDeCamara (String nameElemento, int  idElemento) async{
    // INICIO DE LA FUNCIONALIDAD DE LA CAMARA
    XFile? imgRuta;
    bool isDialogOpen  = false;

    imgRuta = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imgRuta != null) {
        
        final File? imagenCar = await compressFile(File(imgRuta.path), 1048576);
        if(imagenCar != null){
          String nameImagen = imagenCar.path;
          imagen = imagenCar;
          // Muestra el indicador de carga
          /*showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            barrierDismissible: stop, // Impide que se cierre el dialog al tocar fuera
            builder: (BuildContext context) {
              return const Dialog(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Cargando...'),
                    ],
                  ),
                ),
              );
            },
          );
          
          // Iniciar un temporizador para cerrar el diálogo después de un tiempo determinado
          Timer? timer = Timer(const Duration(seconds: 20), () {
            // Verifica si el diálogo aún está abierto y ciérralo
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
              // Muestra un mensaje indicando que la operación tomó demasiado tiempo
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La operación está tardando demasiado.')));
            }
          });

          try {
            bool checkPic = await agregarElementoBD(nameElemento, imagen!, nameImagen);
            
            // Cancela el temporizador si la función termina antes de los 30 segundos
            timer.cancel();
            setState(() {
              stop = true;
            });
            
            if(checkPic){
            await _guardadoElementosSP(nameElemento); //guarda elementos en Shered Preferences por si el usuario no cierra sesion
            setState(() {
              _funtIconChange(idElemento);  //funcion que cambia el icono de de la  camara y status de captura
              _contFts++;
              guardadoElementCont();  //guarda el contador en el shared preferences
              if(_contFts == 9){
                _botonDeshabilitado = true;
              }
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inspección unitaria exitosa')));
            });
            
          }else{
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar el elemento')));
          }
        } catch (e) {
            // Maneja cualquier excepción que pueda ocurrir aquí
        } finally {
            // Asegúrate de cerrar el diálogo de carga si aún está abierto
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
        }*/
           showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  // Establece el estado del diálogo como abierto
                  isDialogOpen = true;
                  return const Dialog(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text('Cargando...'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );

          bool checkPic = await agregarElementoBD(nameElemento, imagen!, nameImagen);
          
          // Cierra el diálogo si está abierto
          if (isDialogOpen) {
            // ignore: use_build_context_synchronously
            Navigator.of(context, rootNavigator: true).pop();
            isDialogOpen = false;
          }

          if(checkPic){
            await _guardadoElementosSP(nameElemento); //guarda elementos en Shered Preferences por si el usuario no cierra sesion
            setState(() {
              _funtIconChange(idElemento);  //funcion que cambia el icono de de la  camara y status de captura
              _contFts++;
              guardadoElementCont();  //guarda el contador en el shared preferences
              if(_contFts == 9){
                _botonDeshabilitado = true;
              }
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inspección unitaria exitosa')));
            });
            
          }else{
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar el elemento')));
          }
        }
    } else {
      imagen = File('');
    }
  }

  Future<File?> compressFile(File file, int targetSize) async {
  final filePath = file.absolute.path;
  
  // Obtener el nombre del archivo y la extensión
  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

  var quality = 95; // Comienza con una calidad alta y reduce si es necesario.
  
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: quality,
    minWidth: 1920,
    minHeight: 1080,
  );

  while (result != null && await result.length() > targetSize && quality > 0) {
    quality -= 5; // Reduce la calidad en incrementos del 5%
    
    result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: quality,
      minWidth: 1920,
      minHeight: 1080,
    );
  }

  return result;
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCIONES RELACIONADAS CON LA BASE DE DATOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
Future<bool> agregarElementoBD(String claveElemento, File elementInspectionFile, String nameImg) async {
    final uri = Uri.parse('https://glorious-sparkle-development.up.railway.app/zagoom/inspeccion-vehicular/guarda-inspeccion');
    var request = http.MultipartRequest('POST', uri)
      ..fields['claveElemento'] = claveElemento
      ..fields['idUsuario'] = _idUser.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'elementInspectionFile',
        elementInspectionFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  
}

Future<bool> changeStatusCarRegistry() async {
  final conexion = await MySqlConnection.connect(ConnectionSettings(
    host: 'bdzgm.c9wmgukmkflh.us-east-2.rds.amazonaws.com',
    port: 3306,
    user: 'admin',
    password: '123456789',
    db: 'BDZAGOOM',
  ));

  try {
    Results status = await conexion.query('UPDATE car_registry_aux SET id_status = 1 WHERE no_motor = ?', [_noMotor]);
    conexion.close();
    return status.affectedRows! > 0; // Devuelve true si se actualizó al menos una fila.
  } catch (e) {
    conexion.close();
    return false; // Devuelve false si hubo un error en la consulta.
  }
}

//FUNCION PARA GUARDAR TODO LO GUARDADO EN SHARED_PREFERENCES A LA BASE DE DATOS
  Future<void> guardar () async {
    final prefs = await SharedPreferences.getInstance();
    bool changeRight = await changeStatusCarRegistry();
    if(changeRight){
      await prefs.remove('elementos');
      await prefs.remove('contFts');
      await prefs.remove('InspProcess');
      await prefs.remove('modelo');
      await prefs.remove('marca');
      await prefs.remove('noMotor');
      await prefs.remove('sesionProcess');
      _botonDeshabilitado  = false ; 
      // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inspección finalizada')),
          );
    }else{
      _botonDeshabilitado  = true; 
      // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error de conexion con BD')),
          );
    }
    setState(() {
    });
    
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
          onPressed: () async {
            await saveReturnCar();
            // ignore: use_build_context_synchronously
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
                _construirFila('Llanta de refaccion', 4),
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
                await guardar();
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
            _miFuncionDeCamara(elemento, idElemento);
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