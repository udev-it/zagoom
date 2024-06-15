import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zagoom/elementos/InicioSesion/paginaprincipal.dart';
import 'package:zagoom/elementos/elementos_vehiculo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FichaVehicular extends StatefulWidget {
  const FichaVehicular({super.key});

  @override
  State<FichaVehicular> createState() => _FichaVehicularState();
}

class _FichaVehicularState extends State<FichaVehicular> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  TextEditingController idAnio = TextEditingController();
  TextEditingController idColor = TextEditingController();
  TextEditingController idNoMotor = TextEditingController();
  int bandera = 0;
  List<CarBrand> _brandsCar = [];
  String? _selectedBrandName;
  List<CarModel> _modelsCar = [];
  bool _marcaSelect = false;
  bool _modelSelect = false;
  String? _selectedModelName;
  int _idUser = 0;

  /*==============================FUNCIONES UTILIZADAS==============================*/
  @override
    void initState() {
      super.initState();
      ordenEjecucion();
      
      
    }

    Future<void> ordenEjecucion() async {
      await recuperadoUsuario();
      await getMarcas();
    }

    Future<void> recuperadoUsuario () async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _idUser = prefs.getInt('idUser') ?? 0;
      });

    }

    Future<void> getMarcas() async {
      final url = Uri.parse('https://glorious-sparkle-development.up.railway.app/zagoom/catalogo/coches');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = json.decode(response.body);
        _brandsCar = jsonList.map((jsonItem) {
          return CarBrand(jsonItem['carBrandId'], jsonItem['brandName']);
        }).toList();
        setState(() {
          _selectedBrandName = _brandsCar[0].brandName;
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener las marcas')),
        );
      }
    }

    Future<void> getModels(String modelo) async {
      final url = Uri.parse('https://glorious-sparkle-development.up.railway.app/zagoom/catalogo/coches/$modelo');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = json.decode(response.body);
        
        setState(() {
          _modelsCar = jsonList.map((jsonItem) {
            return CarModel(jsonItem['carModelId'], jsonItem['carModelName']);
          }).toList();
          _selectedModelName = _modelsCar[0].carModelName;
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener los modelos')),
        );
      }
    }
    Future<void> addCar() async {
      final url = Uri.parse('https://glorious-sparkle-development.up.railway.app/zagoom/inspeccion-vehicular/guarda-registro');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'anio': idAnio.text,
          'carModel': _selectedModelName,
          'color': idColor.text,
          'idUsuario': _idUser,
          'noMotor': idNoMotor.text
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos guardados correctamente')),
                );
         
      } else {
         // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al guardar los datos')),
                );
      }
    }

    String? validateAnio(String? value) {
      if (value == null || value.isEmpty) {
        return 'El campo es obligatorio';
      }
      if (value.length != 4 || int.tryParse(value) == null) {
        return 'Ingrese un año válido (4 dígitos)';
      }
      return null;
    }

    String? validateNoMotor(String? value) {
      if (value == null || value.isEmpty) {
        return 'El campo es obligatorio';
      }
      return null;
    }

    String? validateRequired(String? value) {
      if (value == null || value.isEmpty) {
        return 'Este campo es obligatorio';
      }
      return null;
    }

    String? validateRequiredSelect(String? value){
      if (!_marcaSelect) {
        return 'Por favor, selecciona una marca';
      }
      return null;
    }
    String? validateRequiredSelModel(int? value){
      if (!_modelSelect) {
        return 'Por favor, selecciona un modelo';
      }
      return null;
    }

    String? validateRequiredInt(int? value) {
      if (value == null || value == 0) {
        return 'Este campo es obligatorio';
      }
      return null;
    }

    Future<void> guardadoFicha () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('marca', _selectedBrandName!);
        prefs.setString('modelo', _selectedModelName!);
        prefs.setInt('InspProcess', bandera); 
    }

    // AGREGADO 04/06/2024
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe presionar uno de los botones.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Está seguro de que desea guardar los datos?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () async {
                guardadoFicha();
                await addCar();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => const ElementosVehiculo()),
                );
              },
            ),
          ],
        );
      },
    );
  }
    /*=========================FUN DE FUNCIONES UTILIZADAS==========================*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ficha vehícular", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(
                  child: Text('Ingrese los datos del vehículo',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  value: _selectedBrandName,
                  onChanged: (String? newValue) {
                    setState((){
                      _selectedBrandName = newValue!;
                      getModels(_selectedBrandName!);
                      _marcaSelect = true;
                      _selectedModelName = _modelsCar[0].carModelName;
                    });
                  },
                  items: _brandsCar.map((CarBrand brand) {
                    return DropdownMenuItem<String>(
                      value: brand.brandName,
                      child: Text(brand.brandName),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequiredSelect
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedModelName,
                  onChanged: _marcaSelect
                      ? (String? newValue) {
                          setState(() {
                            _selectedModelName = newValue!;
                            _modelSelect = true;
                          });
                        }
                      : null, // Si _isDropdownEnabled es falso, no se ejecutará el onChanged
                  items: _modelsCar.map((CarModel model) {
                    return DropdownMenuItem<String>(
                      value: model.carModelName,
                      child: Text(model.carModelName),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'modelo',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequiredSelect
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: idAnio,
                  decoration: const InputDecoration(
                    labelText: 'Año',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateAnio,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: idColor,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateRequired,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: idNoMotor,
                  decoration: const InputDecoration(
                    labelText: 'No. de Motor',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateNoMotor,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Los campos son válidos, puedes continuar
                      bandera = 1;
                      await _showConfirmationDialog();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const ElementosVehiculo()));
                    }
                  },
                  child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CarBrand {
  final int carBrandId;
  final String brandName;

  CarBrand(this.carBrandId, this.brandName);
}
class CarModel {
  final int carModelId;
  final String carModelName;

  CarModel(this.carModelId, this.carModelName);
}