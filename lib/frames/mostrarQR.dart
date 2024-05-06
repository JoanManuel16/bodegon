import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
import 'package:flutter_application_1/models/product_to_send_model.dart';
import 'package:flutter_application_1/widget/qr.dart';
import 'package:path_provider/path_provider.dart';

class MostrarQR extends StatefulWidget {
  const MostrarQR({key});

  @override
  State<MostrarQR> createState() => _MostrarQRState();
}

class _MostrarQRState extends State<MostrarQR> {
  List<ProductToSendModel> _productos = [];
  String data = '';

  Future<void> _refrech() async {
    await Future.delayed(Duration(seconds: 1));
    await _crearJson();
  }

  _cargarProductos() async {
    List<ProductToSendModel> aux =
        await ConextionBD.getAllMovimietnoByCodigo(0);
    setState(() {
      _productos = aux;
    });
  }

  Future<Map<String, int>> _confirmar() async {
    final mapa = <String, int>{};
    for (final producto in _productos) {
      if (mapa.containsKey(producto.codigo)) {
        final cantidadActual = mapa[producto.codigo]!;
        mapa['${producto.codigo}'] = cantidadActual + producto.cantidad!;
      } else {
        mapa['${producto.codigo}'] = producto.cantidad!;
      }
    }
    return mapa;
  }

  _actualizarExistencias(Map<String, int> codigos) async {
    await ConextionBD.actualizarExistencia(codigos);
    await _crearJson();
    await _notificar();
    data = '';
  }

  _notificar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green, content: Text('Movimiento realizado')),
    );
  }

  _crearJson() async {
    final directory = await getDownloadsDirectory();
    final File file;
    if (Platform.isAndroid || Platform.isWindows) {
      file = File('${directory?.path}/productos.json');
    } else {
      file = File(
          '${Directory('${(await getApplicationCacheDirectory()).path}/../..').uri.path}productos.json');
    }
    final List<Map<String, dynamic>> x = List.generate(
        _productos.length, (i) => _productos[i].toJsonWithDestiny());
    final jsonString = jsonEncode(x);
    //print(jsonString);
    setState(() {
      data = jsonString;
    });
    await file.writeAsString(jsonString);
  }

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _actualizarExistencias(await _confirmar());
        },
        label: const Text('Confirmar'),
        icon: const Icon(Icons.input_outlined, color: Colors.lightGreen),
      ),
      body: Center(
          child: RefreshIndicator(
        onRefresh: () async {
          await _refrech();
        },
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Center(
              child: QRCodeW(
                qrData: data,
                qrSize: 500,
              ),
            );
          },
        ),
      )),
    );
  }
}
