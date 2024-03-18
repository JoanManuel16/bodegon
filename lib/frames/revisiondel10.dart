import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class RevisioDel10 extends StatefulWidget {
  const RevisioDel10({Key? key}) : super(key: key);

  @override
  State<RevisioDel10> createState() => _RevisioDel10State();
}

class _RevisioDel10State extends State<RevisioDel10> {
  List<Producto> producto = [];
  Future<bool> _isOver10() async {
    return await ConextionBD.isOver10();
  }

  _insertRevisado(List<Producto> x) async {
    DateTime d = DateTime.now();
    for (var element in x) {
      int? x = element.idInventario;
      await ConextionBD.insertRevisados(x!, d.toString());
    }
  }

  _getRaondom() async {
    if (!await _isOver10()) {
      await ConextionBD.eliminarRevisados();
    }
    List<Producto> aux = await ConextionBD.getRandom();
    setState(() {
      producto = aux;
    });
    _insertRevisado(producto);
  }
  _notificar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green, content: Text('Reporte generado en el escritorio')),
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
  for (var p in producto) {
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
          _notificar();
        return content;
      },
    ),
  );
 final directory = await getDownloadsDirectory();
 print(directory);
  final output = File('${directory!.path}/reporte.pdf');
  await output.writeAsBytes(await pdf.save());
}

  @override
  void initState() {
    super.initState();
    _getRaondom();
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
      appBar: AppBar(
        title: const Text('Productos de obtenidos del 10%'),
        backgroundColor: Theme.of(context).focusColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: producto.length,
                itemBuilder: (context, index) {
                  Producto p = producto[index];

                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(p.nombre ?? ''),
                          subtitle: Text(
                            'Código: ${p.codigo ?? ''}\nCantidad: ${p.cantidad ?? ''}\nPrecio Individual: ${p.precioIndividual ?? ''}\nunidad de medida: ${p.um ?? ''}\nfecha de introduccion: ${p.fecha ?? ''}\nResponsable: ${p.nombrePersona ?? ''}',
                          ),
                          trailing: Text(
                            'Precio: \$${p.precioIndividual ?? ''}',
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
