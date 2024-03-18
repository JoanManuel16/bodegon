import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';

class MostrarEntradaW extends StatefulWidget {
  const MostrarEntradaW({super.key});

  @override
  State<MostrarEntradaW> createState() => _MostrarEntradaWState();
}

class _MostrarEntradaWState extends State<MostrarEntradaW> {
  List<Producto> entradas = [];
  List<Producto> _productosFiltrados = [];
  TextEditingController _searchController = TextEditingController();
  _cargarEntrada() async {
    List<Producto> aux = await ConextionBD.cargarEntradas();
    setState(() {
      entradas = aux;
      _productosFiltrados=entradas;
    });
  }

  void _filtrarProductos(String query) {
    List<Producto> filtrados = entradas.where((producto) {
      final nombre = producto.nombre?.toLowerCase() ?? '';
      final codigo = producto.codigo?.toLowerCase() ?? '';
      final fecha = producto.fecha?.toLowerCase() ?? '';
      return nombre.contains(query.toLowerCase()) ||
          codigo.contains(query.toLowerCase()) ||
          fecha.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _productosFiltrados = filtrados;
    });
  }

  @override
  void initState() {
    _cargarEntrada();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         // _generatePDF();
        },
        label: Text('Generar Reporte'),
        icon: const Icon(Icons.picture_as_pdf),
      ),
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
              child: ListView.builder(
                itemCount: _productosFiltrados.length,
                itemBuilder: (context, index) {
                  Producto producto = _productosFiltrados[index];
                  if (_productosFiltrados.isEmpty) {
                    return Icon(Icons.inventory_2_outlined);
                  }
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(producto.nombre ?? ''),
                          subtitle: Text(
                            'Código: ${producto.codigo ?? ''}\nfecha de introduccion: ${producto.fecha ?? ''}\nResponsable: ${producto.nombrePersona ?? ''}\ncantodad:${producto.cantidad}',
                          ),
                        ),
                      
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
