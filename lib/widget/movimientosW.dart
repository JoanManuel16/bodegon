import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';

class MovimietnoW extends StatefulWidget {
  const MovimietnoW({super.key});

  @override
  State<MovimietnoW> createState() => _MovimietnoWState();
}

class _MovimietnoWState extends State<MovimietnoW> {
  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  String _selectedItem = '';
  List<String> _dropdownItems = [];
  String _selectedIteam2 = '';
  List<String> _dropdownItems2 = [];
  String _destino = '';
  List<String> _destinoList = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController dialogController = TextEditingController();
  List<Producto> prodctoSeleccionado = [];
  _cargarTipos() async {
    List<String> aux = await ConextionBD.getAlltiposProducto();
    setState(() {
      _dropdownItems = aux;
      _selectedItem = _dropdownItems[0];
    });
  }

  _cargarProductosByGrupo(int idGrupo) async {
    List<Producto> aux = await ConextionBD.getAllProductoByGrupos(idGrupo);
    setState(() {
      _productos = aux;
      _productosFiltrados = aux;
    });
  }

  _cargarTiposMovimiento() async {
    List<String> aux = await ConextionBD.getAllTiposMovimientos();
    setState(() {
      _dropdownItems2 = aux;
      _selectedIteam2 = _dropdownItems2[0];
    });
  }
 _cargarDestinos() async {
    List<String> aux = await ConextionBD.getAllDestinos();
    setState(() {
      _destinoList = aux;
      _destino = _destinoList[0];
    });
  }
  Future<void> _refrech() async {
    await Future.delayed(Duration(seconds: 1));
    await _cargarProductosByGrupo(_dropdownItems.indexOf(_selectedItem) + 1);
  }

  void _filtrarProductos(String query) {
    List<Producto> filtrados = _productos.where((producto) {
      final nombre = producto.nombre?.toLowerCase() ?? '';
      final codigo = producto.codigo?.toLowerCase() ?? '';
      final um = producto.um?.toLowerCase() ?? '';
      return nombre.contains(query.toLowerCase()) ||
          codigo.contains(query.toLowerCase()) ||
          um.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _productosFiltrados = filtrados;
    });
  }

  Future<int?> _showNumberDialog(BuildContext context, int? maxNumber) async {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('La cantidad deseada'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(maxNumber.toString().length),
            ],
            decoration: InputDecoration(
              hintText: 'Introduce un número entre 1 y $maxNumber',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                final number = int.tryParse(controller.text);
                if (number != null && number >= 1 && number <= maxNumber!) {
                  Navigator.of(context).pop(number);
                  setState(() {
                    _cargarProductosByGrupo(
                        _dropdownItems.indexOf(_selectedItem) + 1);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Introduce un número válido entre 1 y $maxNumber',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _agregarTipoDeCambio(BuildContext context) async {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String? validateInput(String? value) {
      if (value == null || value.isEmpty) {
        return 'Este campo es obligatorio';
      }
      final numbersOnly = RegExp(r'^[a-zA-Z]+$');
      ;
      if (numbersOnly.hasMatch(value)) {
        return null;
      }
      return 'Este campo solo permite letras';
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar tipo de movimiento'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textController,
              validator: validateInput,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nuevo tipo de movimiento',
              ),
            ),
          ),
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
                  await _agregarTipoMovimiento(textController.text);
                  _notificar('Tipo de movimiento agregado', Colors.green);
                  await _cargarTiposMovimiento();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _notificar(String texto,Color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Color,
          content: Text(texto)),
    );
  }

  @override
  void initState() {
    _cargarTipos();
    _cargarProductosByGrupo(1);
    _cargarTiposMovimiento();
    _cargarDestinos();
    super.initState();
  }

  _agregarTipoMovimiento(String tipoMovimiento) async {
    await ConextionBD.agregarTipoMovimiento(tipoMovimiento);
  }

 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            value: _selectedItem,
            onChanged: (value) {
              setState(() {
                _selectedItem = value!;
                _cargarProductosByGrupo(_dropdownItems.indexOf(value) + 1);
              });
            },
            items: _dropdownItems.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Familias de producto',
            ),
          ),
        ),
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            value: _destino,
            onChanged: (value) {
              setState(() {
                _selectedItem = value!;
                _cargarProductosByGrupo(_dropdownItems.indexOf(value) + 1);
              });
            },
            items: _destinoList.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Destino',
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedIteam2,
                    onChanged: (value) {
                      setState(() {
                        _selectedIteam2 = value!;
                      });
                    },
                    items: _dropdownItems2.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Movimiento',
                    ),
                  ),
                ),
                IconButton(
                    onPressed: ()async {
                      await _agregarTipoDeCambio(context);
                    },
                    icon: Icon(Icons.add))
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              _filtrarProductos(value);
            },
            decoration: const InputDecoration(
              labelText: 'Buscar producto',
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: _refrech,
              child: ListView.builder(
                itemCount: _productosFiltrados.length,
                itemBuilder: (context, index) {
                  Producto producto = _productosFiltrados[index];
                  if (_productosFiltrados.isEmpty) {
                    return const Icon(Icons.inventory_2_outlined);
                  }
                  return InkWell(
                    onTap: () async {
                      String? codigo = producto.codigo;
                      int? ccantidad =
                          await _showNumberDialog(context, producto.cantidad);
                      await ConextionBD.addMovimietoDone(
                          codigo!, ccantidad!, _selectedIteam2,_destino);
                      _notificar('Producto agregado a la lista',Colors.green);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(producto.nombre ?? ''),
                            subtitle: Text(
                              'Código: ${producto.codigo ?? ''}\nCantidad: ${producto.cantidad ?? ''}\nPrecio Individual: ${producto.precioIndividual ?? ''}\nunidad de medida: ${producto.um ?? ''}\nfecha de introduccion: ${producto.fecha ?? ''}\nResponsable: ${producto.nombrePersona ?? ''}',
                            ),
                            trailing: Text(
                              'Precio: \$${producto.precioIndividual ?? ''}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
