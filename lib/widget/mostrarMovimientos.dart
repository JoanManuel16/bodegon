import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';

class MostrarMovimietosW extends StatefulWidget {
  const MostrarMovimietosW({super.key});

  @override
  State<MostrarMovimietosW> createState() => _MostrarMovimietosWState();
}

class _MostrarMovimietosWState extends State<MostrarMovimietosW> {
    List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  TextEditingController _searchController = TextEditingController();
  _cargarProductos()async{
      List<Producto> aux = await ConextionBD.getAllMovimietnoByCodigo(1);
      setState(() {
        _productos =aux;
         _productosFiltrados = aux;
      });
  }
  
  @override
  void initState() {
    super.initState();
    _cargarProductos();
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
  Widget build(BuildContext context) {
    
    return Column(
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
                      color: Colors.green[400],
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(producto.nombre ?? ''),
                            subtitle: Text(
                              'Código: ${producto.codigo ?? ''}\nCantidad: ${producto.cantidad ?? ''} Cantidad restante: ${producto.cantidadRest}\nPrecio Individual: ${producto.precioIndividual ?? ''}\nunidad de medida: ${producto.um ?? ''}\nfecha de introduccion: ${producto.fecha ?? ''}\nResponsable: ${producto.nombrePersona ?? ''}',
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
        ],
      );
  }
}