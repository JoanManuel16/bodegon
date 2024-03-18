import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/mostrarModificacionesW.dart';

class MostrarModificaciones extends StatelessWidget {
  const MostrarModificaciones({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificaciones a el tipo de cambio'),
        backgroundColor: Theme.of(context).focusColor,
      ),
      body: const MostrarModificacionesW(),
    );
  }
}
