import 'package:flutter/material.dart';
import 'package:flutter_application_1/bd.dart';
import 'package:flutter_application_1/models/modificaion.dart';

class MostrarModificacionesW extends StatefulWidget {
  const MostrarModificacionesW({super.key});

  @override
  State<MostrarModificacionesW> createState() => _MostrarModificacionesWState();
}

class _MostrarModificacionesWState extends State<MostrarModificacionesW> {
  List<Modificacion> modificaciones = [];

  _obtenerModificaicones() async {
    List<Modificacion> aux = await ConextionBD.getAlltiposMOdificaciones();
    setState(() {
      modificaciones = aux;
    });
  }

  @override
  void initState() {
    _obtenerModificaicones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: modificaciones.length,
      itemBuilder: (context, index) {
        return Card(child: Column(
          children: [ListTile(
          title: Text('${modificaciones[index].moneda}\nResponsable:${modificaciones[index].persona}',
              style: const TextStyle(fontSize: 24)),
          trailing: Text(
            '\$ ${modificaciones[index].cambio}',
            style: const TextStyle(fontSize: 24),
          ),
          subtitle: Text(
            'Fecha de modificacion ${modificaciones[index].fecha}',
            style: const TextStyle(fontSize: 24),
          ),
          
        )],
        ),);
      },
    );
  }
}
