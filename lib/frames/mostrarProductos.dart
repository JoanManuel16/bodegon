import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/mostrarProductoW.dart';

class MostrarProductos extends StatelessWidget {
  const MostrarProductos({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('Listado de Productos'),
            backgroundColor: Theme.of(context).focusColor,
          ),
  body:  MostrarProductoW(),
    );
  }
}