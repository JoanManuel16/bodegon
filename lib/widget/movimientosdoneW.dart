
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
class MovimientosDoneW extends StatefulWidget {
  const MovimientosDoneW({super.key});

  @override
  State<MovimientosDoneW> createState() => _MovimientosDoneWState();
}

class _MovimientosDoneWState extends State<MovimientosDoneW> {
  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  TextEditingController _searchController = TextEditingController();

  _cargarProductos() async {
    List<Producto> aux = await ConextionBD.getAllMovimietnoByCodigo(0);
    setState(() {
      _productos = aux;
      _productosFiltrados = aux;
    });
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

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _refrech() async {
    await Future.delayed(Duration(seconds: 1));
    await _cargarProductos();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                  itemCount: _productosFiltrados.length,
                  itemBuilder: (context, index) {
                    Producto producto = _productosFiltrados[index];
                    if (_productosFiltrados.isEmpty) {
                      return const Icon(Icons.inventory_2_outlined);
                    }
                    return InkWell(
                      onTap: () async {},
                      child: Card(
                        color: Colors.red[100],
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(producto.nombre ?? ''),
                              subtitle: Text(
                                'Código: ${producto.codigo ?? ''}\nCantidad: ${producto.cantidad ?? ''} Cantidad Restante: ${producto.cantidadRest}\nPrecio Individual: ${producto.precioIndividual ?? ''}\nunidad de medida: ${producto.um ?? ''}\nfecha de introduccion: ${producto.fecha ?? ''}\nResponsable: ${producto.nombrePersona ?? ''}',
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
      ),
    );
  }
}
