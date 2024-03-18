import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/mostrarMonedaW.dart';

class MostarMonedas extends StatelessWidget {
  const MostarMonedas({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monedas'),
        backgroundColor: Theme.of(context).focusColor,
      ),
      body: MostrarMonedaW(),
    );
  }
}
