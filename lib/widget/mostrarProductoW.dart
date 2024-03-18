import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
class MostrarProductoW extends StatefulWidget {
  const MostrarProductoW({Key? key});

  @override
  State<MostrarProductoW> createState() => _MostrarProductoWState();
}

class _MostrarProductoWState extends State<MostrarProductoW> {
  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  String _selectedItem = '';
  List<String> _dropdownItems = [];
  TextEditingController _searchController = TextEditingController();

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

  void _eliminarProducto(Producto producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar producto'),
          content:
              Text('¿Estás seguro que quieres eliminar ${producto.nombre}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String? aux = producto.codigo;
                await ConextionBD.deleteProducto(aux!);
                Navigator.of(context).pop(); // Cerrar el diálogo
                _cargarProductosByGrupo(_dropdownItems.indexOf(_selectedItem) +
                    1); // Actualizar la lista de productos
                    _notificarEliminacion('producto eliminado',Colors.red);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
  void _notificarEliminacion(String text, Color c )  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: c,
        content: Text(text)),
    );
  }
  Future<void> _generatePDF() async {
  final pdf = pw.Document();

  // Crear la tabla
  final List<List<String>> tableData = [];
  tableData.add([
    'Código',
    'Nombre',
    'Cantidad',
    'Precio Individual',
    'Fecha',
    'Responsable',
  ]);
  for (var p in _productos) {
    tableData.add([
      p.codigo ?? '',
      p.nombre ?? '',
      p.cantidad?.toString() ?? '',
      p.precioIndividual?.toString() ?? '',
      p.fecha ?? '',
      p.nombrePersona ?? '',
    ]);
  }


  final table = pw.Table.fromTextArray(
    data: tableData,
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    cellAlignment: pw.Alignment.center,
    cellHeight: 30,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerLeft,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.center,
      5: pw.Alignment.centerLeft,
    },
  );

  // Agregar la tabla al documento
  pdf.addPage(
    pw.MultiPage(
       build: (pw.Context context) {
        final List<pw.Widget> content = [];

          content.add(
           table
          );
          
        return content;
      },
    ),
  );
 final directory = await getDownloadsDirectory();
 print(directory);
  final output = File('${directory!.path}/reporteDeProducto$_selectedItem.pdf');
  await output.writeAsBytes(await pdf.save());
  _notificarEliminacion('Reporte creado en la carpeta de descargas', Colors.green);
}

  @override
  void initState() {
    _cargarTipos();
    _cargarProductosByGrupo(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _generatePDF();
        },
        label: Text('Generar Reporte'),
        icon: const Icon(Icons.picture_as_pdf),
      ),
      body: Column(
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
                  if(_productosFiltrados.isEmpty){
                    return Icon(Icons.inventory_2_outlined);
                  }
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(producto.nombre ?? ''),
                          subtitle: Text(
                            'Código: ${producto.codigo ?? ''}\nCantidad: ${producto.cantidad ?? ''}\nPrecio Individual: ${producto.precioPonderado ?? ''}\nPrecioPonderado:${producto.precioPonderado}\nunidad de medida: ${producto.um ?? ''}\nfecha de introduccion: ${producto.fecha ?? ''}\nResponsable: ${producto.nombrePersona ?? ''}',
                          ),
                          trailing: Text(
                            'Precio: \$${producto.precioIndividual ?? ''}',
                          ),
                        ),
                        ButtonBar(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("/editarProducto",arguments: {
                                      'producto':producto
                                    });
                                // Acción al presionar el botón de edición
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                 _eliminarProducto(producto);
                                
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
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
