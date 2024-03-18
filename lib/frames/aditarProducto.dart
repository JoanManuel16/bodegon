import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Pproducto.dart';
import 'package:flutter_application_1/widget/editarProdductoW.dart';

class EditarProducto extends StatelessWidget {
  EditarProducto({key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Producto> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Producto>;
    String? codigo = arguments['producto']!.codigo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar el producto '),
        backgroundColor: Theme.of(context).focusColor,
      ),
      body: EditarProductoW(
        codigo: codigo,
      ),
    );
  }
}
