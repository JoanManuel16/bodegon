import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/drawer.dart';
import 'package:flutter_application_1/widget/mosttrarEntradaW.dart';

class MostrarEntrada extends StatelessWidget {
  const MostrarEntrada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: drawer(context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).focusColor,
        title: Text('Movimientos de entrada'),
      ),
      body: MostrarEntradaW(),
    );
  }
}
