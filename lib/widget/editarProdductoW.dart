import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EditarProductoW extends StatefulWidget {
  String? codigo;
  EditarProductoW({Key? key, required this.codigo});

  @override
  State<EditarProductoW> createState() => _EditarProductoWState();
}

class _EditarProductoWState extends State<EditarProductoW> {
  TextEditingController _nombreProducto = TextEditingController();
  TextEditingController _codigo = TextEditingController();
  TextEditingController _precioIndividual = TextEditingController();
  TextEditingController _cantidad = TextEditingController();
  TextEditingController _persona = TextEditingController();
  String _familiaDeProducto = '';
  List<String> _itemsFamiliaProducto = [];
  String _uniadMedida = '';
  List<String> _itemsUnidadMedida = [];
  int _cantidadAnterior = 0;
  double _precioAnteriro = 0;
  List<String> personas = [];
  String persona = '';

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
      _itemsUnidadMedida = aux;
      _uniadMedida = _itemsUnidadMedida[0];
    });
  }

  _cargarTipos() async {
    List<String> aux = await ConextionBD.getAlltiposProducto();
    setState(() {
      _itemsFamiliaProducto = aux;
      _familiaDeProducto = _itemsFamiliaProducto[0];
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
  void initState() {
    _cargarUnidadesMedida();
    _cargarTipos();
    _cargarPersonas();
    super.initState();
  }

  Future<void> _actualizarProducto(Producto p) async {
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    int cantidadInsertada = int.parse(_cantidad.text) - _cantidadAnterior;
    if (cantidadInsertada > 0) {
      await ConextionBD.insertMovimientoEntrada(formattedDate,
          cantidadInsertada, _codigo.text, persona, _nombreProducto.text);
      if (_precioAnteriro - double.parse(_precioIndividual.text) != 0) {
        p.precioPonderado= int.parse(_cantidad.text)*double.parse(_precioIndividual.text)/int.parse(_cantidad.text);
        await ConextionBD.updateProducto(p);
      }
    }

    Navigator.of(context).pushNamed("/");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green, content: Text('Producto actualizado')),
    );
  }

  Future<void> _mostrarDialogoConfirmacion(Producto p) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar actualización'),
          content:
              const Text('¿Está seguro de que desea actualizar el producto?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                _actualizarProducto(p);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _notificarEliminacion(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: color, content: Text(texto)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Producto> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Producto>;
    final formKey = GlobalKey<FormState>();
    String? codigo = arguments['producto']!.codigo;
    _codigo.text = codigo!;
    int? idGrupo = arguments['producto']!.idGrupo;
    String? nombreProducto = arguments['producto']!.nombre;
    _nombreProducto.text = nombreProducto!;
    String? nombrePersona = arguments['producto']!.nombrePersona;
    _persona.text = nombrePersona!;
    double? precioIndividual = arguments['producto']!.precioIndividual;
    _precioIndividual.text = "$precioIndividual";
    String? unidadesMedia = arguments['producto']!.um;
    int? cantidad = arguments['producto']!.cantidad;
    _cantidad.text = cantidad.toString();
    String? fecha = arguments['producto']!.fecha;
    _uniadMedida = unidadesMedia!;
    _familiaDeProducto = _itemsFamiliaProducto.elementAt(idGrupo! - 1);
    _cantidadAnterior = cantidad!;
    _precioAnteriro = precioIndividual!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Expanded(
                  child: TextFormField(
                    controller: _codigo,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Código',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _familiaDeProducto,
                      onChanged: (value) {
                        setState(() {
                          _familiaDeProducto = value!;
                        });
                      },
                      items: _itemsFamiliaProducto.map((item) {
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
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _nombreProducto,
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
                  decoration: const InputDecoration(
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
                        controller: _precioIndividual,
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
                          labelText: 'Precio individual',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                    height: 10,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: _cantidad,
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
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
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
                      value: _uniadMedida,
                      onChanged: (value) {
                        setState(() {
                          _uniadMedida = value!;
                        });
                      },
                      items: _itemsUnidadMedida.map((item) {
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      _mostrarDialogoConfirmacion(Producto(
                          fecha: fecha,
                          nombrePersona: persona,
                          nombre: _nombreProducto.text,
                          codigo: codigo,
                          idGrupo: idGrupo,
                          um: _uniadMedida,
                          precioIndividual:
                              double.parse(_precioIndividual.text),
                          cantidad: int.parse(_cantidad.text)));
                    }
                  },
                  child: const Text('Actualizar'),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
