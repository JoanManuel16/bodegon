import 'package:flutter/material.dart';
import 'package:flutter_application_1/frames/mostrarQR.dart';
import 'package:flutter_application_1/widget/movimientosW.dart';
import 'package:flutter_application_1/widget/movimientosdoneW.dart';

class Movimiento extends StatefulWidget {
  const Movimiento({Key? key});

  @override
  _MovimientoState createState() => _MovimientoState();
}

class _MovimientoState extends State<Movimiento> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MovimietnoW(), // Página 1
    const MovimientosDoneW(), // Página 2
    const MostrarQR()
  ];

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Movimientos'),
        backgroundColor: Theme.of(context).focusColor,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle,color: Colors.green,),
            label: 'Productos Seleccionados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2_rounded,color: Colors.green,),
            label: 'Exportar',
          ),
        ],
      ),
    );
  }
}