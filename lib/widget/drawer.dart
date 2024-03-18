import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
 //ejemplo para llevar el csv a la clase

   _notifica(context, String texto,Color c){

     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: c, content: Text(texto,)));
   }
  Future<void> seleccionarArchivo(context) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'], // Solo permite archivos .csv
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      print('Archivo seleccionado: $filePath');

      // Leer el contenido del archivo CSV
      final csvData = await File(filePath).readAsString();
      final lines = csvData.split('\n');
      // Crear objetos Producto a partir de las líneas del archivo
      List<Producto> productos = [];
      bool flag=true;
      for (var line in lines) {
        if(line.isEmpty||flag){
          flag=false;
          continue;
        }
        final parts = line.split(',');
          final codigo = parts[1].replaceAll('"', '');
          final idGrupo = int.tryParse(parts[2].replaceAll('"', '')) ?? 0;
          final um = parts[3].replaceAll('"', '');
          final precioIndividual = double.tryParse(parts[4].replaceAll('"', '')) ?? 0.0;
          final cantidad = int.tryParse(parts[5].replaceAll('"', '')) ?? 0;
          final nombre = parts[6].replaceAll('"', '');
          final nombrePersona = parts[9].replaceAll('"', '');
          final fecha = parts[10].replaceAll('"', '');
          final producto = Producto(
            cantidadRest: null,
            fecha: fecha,
            nombrePersona: nombrePersona,
            nombre: nombre,
            codigo: codigo,
            idGrupo: idGrupo,
            um: um,
            precioIndividual: precioIndividual,
            cantidad: cantidad,
          );
          productos.add(producto);
      }

      // Imprimir los objetos Producto
      for (var producto in productos) {
       await ConextionBD.insertProducto(producto);
       await ConextionBD.insertMovimientoEntrada(producto.fecha!, producto.cantidad!, producto.codigo!, producto.nombrePersona!,producto.nombre!);
      }
     _notifica(context, 'Productos agregados correctamente', Colors.green);
    } else {
     _notifica(context, 'No se selecciono ningun archivo', Colors.red);
    }
  } catch (e) {
   _notifica(context, 'Error al seleccionar el archivo', Colors.red);
  }
}

  
Drawer drawer(context) {
  return Drawer(
    backgroundColor: Theme.of(context).focusColor,
    shadowColor: Theme.of(context).focusColor,
    child: Container(
      width: 250,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).focusColor,
                image: const DecorationImage(
                    image: AssetImage('assets/draweheader.jfif'),
                    fit: BoxFit.cover)),
            child: const Text(''),
          ),
          const Center(
            child: const Text(
              "Productos",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const Divider(endIndent: 10, indent: 10),
          ListTile(
            title: const Text('Agregar al Inventario'),
            onTap: () {
              Navigator.of(context).pushNamed("/addProducto");
            },
            leading: const Icon(Icons.add),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          ListTile(
            title: const Text('Mostrar Productos'),
            onTap: () {
              Navigator.of(context).pushNamed("/mostarProductos");
            },
            leading: const Icon(Icons.info),
          ),
          ListTile(
            title: const Text('Revision del 10%'),
            onTap: () {
              Navigator.of(context).pushNamed("/revision10");
            },
            leading: const Icon(Icons.info),
          ),
          ListTile(
            title: const Text('Realizar Movimiento'),
            onTap: () {
              Navigator.of(context).pushNamed("/addMovimiento");
            },
            leading: const Icon(Icons.move_to_inbox_sharp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.grey),
            ),
          ),ListTile(
            title: const Text('Mostrar Movimientos de salida'),
            onTap: () {
              Navigator.of(context).pushNamed("/mostrarMovimiento");
            },
            leading: const Icon(Icons.info),
            ),ListTile(
            title: const Text('Mostrar Movimientos de entrada'),
            onTap: () {
              Navigator.of(context).pushNamed("/mostrarEntrada");
            },
            leading: const Icon(Icons.info),
            ),
            ListTile(
            title: const Text('Cargar Productos desde un archivo'),
            onTap: ()async {
              seleccionarArchivo(context);
            },
            leading: const Icon(Icons.info),
            ),
          const Divider(endIndent: 10, indent: 10),
          const SizedBox(
            width: 16,
          ),
          const Center(
            child: Text(
              "Monedas",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const Divider(endIndent: 10, indent: 10),
          ListTile(
            title: const Text('Mostrar Monedas'),
            onTap: () {
              Navigator.of(context).pushNamed("/mostrarMoneda");
            },
            leading: const Icon(Icons.info),
          ),
          ListTile(
            title: const Text('Mostrar Modificaciones en el tipo de cambio'),
            onTap: () {
              Navigator.of(context).pushNamed("/mostarMod");
            },
            leading: const Icon(Icons.info),
          ),
          const Divider(endIndent: 10, indent: 10),
        ],
      ),
    ),
  );
}