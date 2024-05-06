import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
import 'package:flutter_application_1/models/moneda.dart';
import 'package:intl/intl.dart';

class AddProducto extends StatefulWidget {
  const AddProducto({Key? key}) : super(key: key);

  @override
  _MyAddProductoState createState() => _MyAddProductoState();
}

class _MyAddProductoState extends State<AddProducto> {
  final _codeController = TextEditingController();
  final _lettersController = TextEditingController();
  final _numbersController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _precioOriginalController = TextEditingController();
  final moneda = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedItem = '';
  List<String> _items = [];
  String _slectedIteam1 = '';
  Moneda _monedaItem = Moneda();
  List<String> _items1 = [];
  List<String> personas = [];
  List<Moneda> monedas = [];
  String persona = '';
  double monedaValue = 0.0;
  String puntoDeVenta = "";

  Map<String, Moneda> mapa = {};
  @override
  void initState() {
    _cargarUnidadesMedida();
    _cargarTipos();
    _cargarPersonas();
    _cargarMonedas();
    super.initState();
  }

  void _notificarInsercion(String x, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: c, content: Text(x)),
    );
  }

  Future<void> _showAddUnitDialogUM() async {
    String? newUnit = await showDialog<String>(
      context: context,
      builder: (context) {
        String? unit;
        return AlertDialog(
          title: const Text('Agregar unidad de medida'),
          content: TextField(
            onChanged: (value) {
              unit = value;
            },
            decoration: const InputDecoration(
              labelText: 'Unidad de medida',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Cerrar el diálogo sin agregar la unidad
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context,
                    unit); // Cerrar el diálogo y pasar la unidad ingresada
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
    if (newUnit != '') {
      await ConextionBD.insertUnidadDeMedida(newUnit!);
      await _cargarUnidadesMedida();
    }
  }

  Future<void> _moneda() async {
    String? newUnit = await showDialog<String>(
      context: context,
      builder: (context) {
        String? unitLetters;
        String? unitNumbers;

        return AlertDialog(
          title: const Text('Agregar Moneda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (value) {
                  unitLetters = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Nueva Moneda',
                ),
                validator: (value) {
                  if (value!.isNotEmpty &&
                      value.contains(RegExp(r'^[a-zA-Z ]+$'))) {
                    return null;
                  }
                  return 'Por favor, ingrese solo letras y espacios';
                },
              ),
              TextFormField(
                onChanged: (value) {
                  unitNumbers = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de cambio',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Cerrar el diálogo sin agregar la unidad
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (unitLetters != null && unitNumbers != null) {
                  Navigator.pop(context,
                      '$unitLetters - $unitNumbers'); // Cerrar el diálogo y pasar las unidades ingresadas
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (newUnit != null) {
      String unitLetters = newUnit.split(' - ')[0];
      String unitNumbers = newUnit.split(' - ')[1];
      await ConextionBD.agregarMoneda(
          unitLetters, int.tryParse(unitNumbers) ?? 0);
    }
  }

  Future<void> _showAddUnitDialogTP() async {
    String? newUnit = await showDialog<String>(
      context: context,
      builder: (context) {
        String? unit;
        return AlertDialog(
          title: const Text('Agregar Familia de Producto'),
          content: TextFormField(
            onChanged: (value) {
              unit = value;
            },
            decoration: const InputDecoration(
              labelText: 'Familia de Producto',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Cerrar el diálogo sin agregar la unidad
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context,
                    unit); // Cerrar el diálogo y pasar la unidad ingresada
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
    if (newUnit != '') {
      await ConextionBD.insertTipoProducto(newUnit!);
      await _cargarTipos();
    }
  }

  Future<void> _personas() async {
    String? newUnit = await showDialog<String>(
      context: context,
      builder: (context) {
        String? unit;
        return AlertDialog(
          title: const Text('Agregar persona'),
          content: TextField(
            onChanged: (value) {
              unit = value;
            },
            decoration: const InputDecoration(
              labelText: 'Persona nueva',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Cerrar el diálogo sin agregar la unidad
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context,
                    unit); // Cerrar el diálogo y pasar la unidad ingresada
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
    if (newUnit != '' || newUnit != null) {
      await ConextionBD.agregarPersona(newUnit!);
      await _cargarPersonas();
    }
  }

  _cargarUnidadesMedida() async {
    List<String> aux = await ConextionBD.unidadesMedia();
    setState(() {
      _items = aux;
      _selectedItem = _items[0];
    });
  }

  _cargarMonedas() async {
    List<Moneda> aux = await ConextionBD.getAlltiposMonedasClass();
    setState(() {
      monedas = aux;
      _monedaItem = monedas[0];
      monedaValue = _monedaItem.cambio!;
      mapa.clear();

      for (int i = 0; i < monedas.length; i++) {
        mapa.addAll({monedas[i].moneda!: monedas[i]});
      }
    });
  }

  _cargarTipos() async {
    List<String> aux = await ConextionBD.getAlltiposProducto();
    setState(() {
      _items1 = aux;
      _slectedIteam1 = _items1[0];
    });
  }

  _cargarPersonas() async {
    List<String> aux = await ConextionBD.getAllPersonas();
    setState(() {
      personas = aux;
      persona = personas[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar producto'),
        backgroundColor: Theme.of(context).focusColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: 'Código',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _slectedIteam1,
                        onChanged: (value) {
                          setState(() {
                            _slectedIteam1 = value!;
                          });
                        },
                        items: _items1.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Familia de Producto',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        _showAddUnitDialogTP();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _lettersController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      final lettersOnly = RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ0-9]+$');
                      if (!lettersOnly.hasMatch(value)) {
                        return 'Este campo solo permite letras';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nombre del Producto',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: _numbersController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            final numbersOnly = RegExp(r'^\d+([,.]\d+)?$');
                            if (!numbersOnly.hasMatch(value)) {
                              return 'Este campo solo permite números con coma';
                            }
                            return null;
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Precio de costo',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: _cantidadController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            final numbersOnly = RegExp(r'^\d+([,.]\d+)?$');
                            if (!numbersOnly.hasMatch(value)) {
                              return 'Este campo solo permite números';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Cantidad',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedItem,
                        onChanged: (value) {
                          setState(() {
                            _selectedItem = value!;
                          });
                        },
                        items: _items.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Unidad de Medida',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        _showAddUnitDialogUM();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: persona,
                        onChanged: (value) {
                          setState(() {
                            persona = value!;
                          });
                        },
                        items: personas.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Persona que agrega el producto',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        _personas();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                /*        const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _monedaItem.moneda,
                        onChanged: (value) {
                          setState(() {
                            _monedaItem = mapa[value]!;
                            monedaValue = _monedaItem.cambio!;
                          });
                        },
                        items: monedas.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.moneda,
                            child: Text(item.moneda!),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Moneda',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: puntoDeVenta,
                        onChanged: (value) {
                          setState(() {
                            puntoDeVenta = value!;
                          });
                        },
                        items: _puntosDeVenta.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Punto de venta',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),*/
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime dt = DateTime.now();
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(dt);
                      if (_formKey.currentState!.validate()) {
                        double precioPonderadoC =
                            double.parse(_numbersController.text) *
                                int.parse(_cantidadController.text) /
                                int.parse(_cantidadController.text);
                        await ConextionBD.insertProducto(Producto(
                            nombrePersona: persona,
                            fecha: formattedDate,
                            precioPonderado: precioPonderadoC,
                            nombre: _lettersController.text,
                            codigo: _codeController.text,
                            idGrupo: _items1.indexOf(_slectedIteam1) + 1,
                            um: _selectedItem,
                            precioIndividual:
                                double.parse(_numbersController.text),
                            cantidad: int.parse(_cantidadController.text)));
                        await ConextionBD.insertMovimientoEntrada(
                            formattedDate,
                            int.parse(_cantidadController.text),
                            _codeController.text,
                            persona,
                            _lettersController.text);
                        _notificarInsercion(
                            'Producto agregado correctamente', Colors.green);
                        _codeController.text = '';
                        _lettersController.text = '';
                        _numbersController.text = '';
                        _cantidadController.text = '';
                        _precioOriginalController.text = '';
                      }
                    },
                    child: const Text('Aceptar'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
