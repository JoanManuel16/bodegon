import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/drawer.dart';

class Principal extends StatelessWidget {
   Principal({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    backgroundColor: Theme.of(context).focusColor,
    title: const Text('Control de Almacen'),
  ),
  drawer: drawer(context),
  body: Center(
    child: Text('Mi cuerpo de la aplicación'),
  ),
);

    
  }
}
