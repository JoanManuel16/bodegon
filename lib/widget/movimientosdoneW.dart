import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
import 'package:flutter_application_1/models/moviemientoToDo.dart';

class MovimientosDoneW extends StatefulWidget {
  const MovimientosDoneW({super.key});

  @override
  State<MovimientosDoneW> createState() => _MovimientosDoneWState();
}

class _MovimientosDoneWState extends State<MovimientosDoneW> {
  List<MovimientoToDo> _movimientos = [];
  List<MovimientoToDo> _movimientosFiltrados = [];
  TextEditingController _searchController = TextEditingController();
  List<String> _dropdownItems2 = [];
  String _selectedIteam2 = "";

  _cargarMovimientos(String mov) async {
    List<MovimientoToDo> aux = await ConextionBD.getAllMovsByType(mov);
    setState(() {
      _movimientos = aux;
      _movimientosFiltrados = aux;
    });
  }

  _cargarTiposMovimiento() async {
    List<String> aux = await ConextionBD.getAllTiposMovimientos();
    setState(() {
      _dropdownItems2 = aux;
      _selectedIteam2 = _dropdownItems2[0];
    });
  }

  void _filtrarProductos(String query) {
    List<MovimientoToDo> filtrados = _movimientos.where((movimiento) {
      final nombre = movimiento.destino?.toLowerCase() ?? '';
      final codigo = movimiento.codigo?.toLowerCase() ?? '';
      final fecha = movimiento.fecha ?? '';
      return nombre.contains(query.toLowerCase()) ||
          codigo.contains(query.toLowerCase()) ||
          fecha.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _movimientosFiltrados = filtrados;
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarMovimientos("movimieto casa");
    _cargarTiposMovimiento();
  }

  Future<void> _refrech() async {
    await Future.delayed(Duration(seconds: 1));
    await _cargarMovimientos("yuca");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                          _cargarMovimientos(_selectedIteam2);
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
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
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
                  itemCount: _movimientosFiltrados.length,
                  itemBuilder: (context, index) {
                    MovimientoToDo producto = _movimientosFiltrados[index];
                    if (_movimientosFiltrados.isEmpty) {
                      return const Icon(Icons.inventory_2_outlined);
                    }
                    return InkWell(
                      onTap: () async {},
                      child: Card(
                        color: Colors.red[100],
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(producto.destino ?? ''),
                              subtitle: Text(
                                'Código: ${producto.codigo ?? ''}\nCantidad: ${producto.cantidad ?? ''}',
                              ),
                              trailing: Text(
                                'Precio: \$${producto.tipoMovimiento ?? ''}',
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
      ),
    );
  }
}
