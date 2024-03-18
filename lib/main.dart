import 'package:flutter/material.dart';
import 'package:flutter_application_1/frames/aditarProducto.dart';
import 'package:flutter_application_1/frames/mostrarEntrada.dart';
import 'package:flutter_application_1/frames/mostrarModificacoines.dart';
import 'package:flutter_application_1/frames/mostrarMonedas.dart';
import 'package:flutter_application_1/frames/mostrarMovimientos.dart';
import 'package:flutter_application_1/frames/mostrarProductos.dart';
import 'package:flutter_application_1/frames/movimietno.dart';
import 'package:flutter_application_1/frames/principal.dart';
import 'package:flutter_application_1/frames/revisiondel10.dart';
import 'package:flutter_application_1/widget/addProducto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.deepPurple
       ),
      debugShowCheckedModeBanner: false,
      title: "EsculTunas",
      initialRoute: "/",
      routes: {
        "/": (context) =>  Principal(),
        "/addProducto": (context) =>  const  AddProducto(),
         "/mostarProductos": (context) => const MostrarProductos(),
        "/editarProducto": (context) =>  EditarProducto(),
        "/mostrarMoneda": (context) => const MostarMonedas(),
        "/mostarMod": (context) => const MostrarModificaciones(),
        "/revision10": (context) => const RevisioDel10(),
        "/addMovimiento": (context) => const Movimiento(),
        "/mostrarMovimiento": (context) => const MostrarMovimietos(),
        "/mostrarEntrada": (context) => const MostrarEntrada(),
      },
    
    );
}

}