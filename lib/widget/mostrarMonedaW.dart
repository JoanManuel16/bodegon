import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/moneda.dart';

class MostrarMonedaW extends StatefulWidget {
  const MostrarMonedaW({super.key});

  @override
  State<MostrarMonedaW> createState() => _MostrarMonedaWState();
}

class _MostrarMonedaWState extends State<MostrarMonedaW> {
  List<Moneda> monedas = [];
  List<String> personas = [];
  String persona = '';
  _obtenerMonedas() async {
    List<Moneda> aux = await ConextionBD.getAlltiposMonedasClass();
    setState(() {
      monedas = aux;
    });
  }
      _cargarPersonas() async {
    List<String> aux = await ConextionBD.getAllPersonas();
    setState(() {
      personas = aux;
      persona = personas[0];
    });
  }

  void _notificarModificacion() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text('Tipo de cambio modificado')),
    );
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

  Future<void> show(BuildContext context, Moneda m) async {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String? validateInput(String? value) {
      if (value == null || value.isEmpty) {
        return 'Este campo es obligatorio';
      }
      final numbersOnly = RegExp(r'^\d+$');
      if (numbersOnly.hasMatch(value)) {
        return null;
      }
      return 'Este campo solo permite números enteros';
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modificar tipo de cambio'),
          content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  TextFormField(
              controller: textController,
              validator: validateInput,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingrese el nuevo tipo de cambio',
              ),
            ), Row(
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
                          labelText: 'Persona que realiza el cambio',
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
                ],
              )),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final value = int.parse(textController.text);
                  await ConextionBD.insertModificacionTipoCambio(m);
                  await ConextionBD.updateTipoCambio(m, value);
                  _obtenerMonedas();
                  _notificarModificacion();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _obtenerMonedas();
    _cargarPersonas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: monedas.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              ListTile(
                title: Text(monedas[index].moneda ?? '',
                    style: const TextStyle(fontSize: 24)),
                trailing: Text(
                  'Tipo de cambio: \$${monedas[index].cambio ?? ''}',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () {
                      show(context, monedas[index]);
                    },
                    icon: const Icon(Icons.edit, size: 32),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
