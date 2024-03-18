import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/mostrarMovimientos.dart';

class MostrarMovimietos extends StatelessWidget {
  const MostrarMovimietos({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).focusColor,
        title: const Text('Movimientos Realizados'),
      ),
      body: const MostrarMovimietosW(),
    );
  }
}
