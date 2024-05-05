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
TextEditingController _searchController = TextEditingController();
 List<Modificacion> _productosFiltrados = [];
  _obtenerModificaicones() async {
    List<Modificacion> aux = await ConextionBD.getAlltiposMOdificaciones();
    setState(() {
      modificaciones = aux;
      _productosFiltrados=aux;
    });
  }

  @override
  void initState() {
    _obtenerModificaicones();
    super.initState();
  }
 void _filtrarProductos(String query) {
    List<Modificacion> filtrados = modificaciones.where((producto) {
      final fecha = producto.fecha?.toLowerCase() ?? '';
      final moneda = producto.moneda?.toLowerCase() ?? '';
      final persona = producto.persona?.toLowerCase() ?? '';
      return fecha.contains(query.toLowerCase()) ||
          moneda.contains(query.toLowerCase()) ||
          persona.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _productosFiltrados = filtrados;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
  children: [
     Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filtrarProductos(value);
              },
              decoration: const InputDecoration(
                labelText: 'Buscar',
              ),
            ),
          ),
    Expanded(
      child: ListView.builder(
        itemCount: _productosFiltrados.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    '${_productosFiltrados[index].moneda}\nResponsable:${_productosFiltrados[index].persona}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  trailing: Text(
                    '\$ ${_productosFiltrados[index].cambio}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  subtitle: Text(
                    'Fecha de modificacion ${_productosFiltrados[index].fecha}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  ],
);

  }
}
