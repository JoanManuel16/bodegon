import 'dart:math';

import 'package:flutter_application_1/models/Pproducto.dart';
import 'package:flutter_application_1/models/modificaion.dart';
import 'package:flutter_application_1/models/moneda.dart';
import 'package:flutter_application_1/models/moviemientoToDo.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class ConextionBD {
  static const String _host = 'localhost';
  static const int _port = 3306;
  static const String _user = 'root';
  static const String _db = 'almacen';
  static MySqlConnection? _conn;

  static Future<MySqlConnection?> _getConexion() async {
    if (_conn == null) {
      var setings =
          ConnectionSettings(db: _db, host: _host, port: _port, user: _user);
      _conn = await MySqlConnection.connect(setings);
    }
    return _conn;
  }

  static Future<void> close() async {
    await _conn?.close();
    _conn = null;
  }

  static Future<Results> _executeQuery(String query) async {
    MySqlConnection? conn = await _getConexion();

    if (conn != null) {
      Results results = await conn.query(query);
      return results;
    } else {
      throw Exception(
          'No se pudo establecer la conexión con la base de datos.');
    }
  }

//---------------------------------Consultas de las unidades de medita ---------------------
  static Future<void> insertUnidadDeMedida(String unidad) async {
    String query = "INSERT INTO unidades (unidad) VALUES ('$unidad')";
    await _executeQuery(query);
  }

  static Future<List<String>> unidadesMedia() async {
    Results results = await _executeQuery('SELECT * FROM unidades');
    List<String> resultados = [];
    for (var row in results) {
      resultados.add(row.fields['unidad']);
    }
    return resultados;
  }
//------------------------------------------------------------------------------------------

//-----------------------------Consulta de los tipos de producto---------------------------
  static Future<void> insertTipoProducto(String producto) async {
    String query =
        "INSERT INTO tiposproducto (tipoDeProducto) VALUES ('$producto')";
    await _executeQuery(query);
  }

  static Future<bool> isOver10() async {
    String query =
        "SELECT IF((COUNT(*) > ((SELECT COUNT(*) FROM producto) * 0.9)), 1, 0) AS resultado FROM revisados";
    Results results = await _executeQuery(query);
    return results.last.fields['resultado'] == 0;
  }

  static eliminarRevisados() async {
    String query = "DELETE   FROM   revisados";
    await _executeQuery(query);
  }

  static insertRevisados(int id, String fecha) async {
    String query =
        "INSERT INTO  revisados (idProducto,fecha) VALUES  ($id,'$fecha')";
    await _executeQuery(query);
  }

  static Future<List<Producto>> getRandom() async {
    List<Producto> productos = [];
    String query =
        "SELECT * FROM producto WHERE idInventario NOT IN (SELECT idProducto FROM revisados)";
    Results results = await _executeQuery(query);
    for (var row in results) {
      Producto p = Producto(
        idInventario: row.fields['idInventario'],
        nombrePersona: row.fields['nombrePersona'],
        fecha: row.fields['fecha'],
        nombre: row.fields['nombre'],
        codigo: row.fields['codigo'],
        idGrupo: 0,
        um: row.fields['um'],
        precioIndividual: row.fields['precioIndicidual'],
        cantidad: row.fields['cantidad'],
      );
      productos.add(p);
    }

    // Obtener el 10% de los valores de manera aleatoria
    int cantidadProductos = productos.length;
    int cantidadRandom = (cantidadProductos * 0.1).ceil();

    // Mezclar los elementos de la lista
    productos.shuffle(Random());

    // Obtener el subconjunto de elementos aleatorios
    List<Producto> productosRandom = productos.sublist(0, cantidadRandom);

    return productosRandom;
  }

  static Future<List<String>> getAlltiposProducto() async {
    Results results = await _executeQuery('SELECT * FROM tiposproducto');
    List<String> resultados = [];
    for (var row in results) {
      resultados.add(row.fields['tipoDeProducto']);
    }
    return resultados;
  }
//------------------------------------------------------------------------------------------

//--------------------------------------Consultas de los productos--------------------------
  static Future<void> insertProducto(Producto producto) async {
    String query =
        "INSERT INTO producto (codigo,idGrupo,um,precioIndicidual,cantidad,nombre,nombrePersona,fecha,precioPonderado,id_punto_de_venta,tipo_de_cambio) VALUES ('${producto.codigo}',${producto.idGrupo},'${producto.um}',${producto.precioIndividual},${producto.cantidad},'${producto.nombre}','${producto.nombrePersona}','${producto.fecha}',${producto.precioPonderado}, ${producto.idPuntodeVenta}, ${producto.tipoDeCambio})";
    await _executeQuery(query);
  }

//Hay un error en esta consulta que no entiendo cual es
  static Future<void> insertMovimientoEntrada(String fecha, int cantidad,
      String codigo, String persona, String nombreProducto) async {
    String query =
        "INSERT INTO movimientoentrada (cantidad,codigoProducto,fecha,persona,nombreProducto) VALUES ($cantidad,'$codigo','$fecha','$persona','$nombreProducto')";
    await _executeQuery(query);
  }

  static Future<void> insertPrecioPonderado(
      String codigo, double precio) async {
    String query =
        "INSERT INTO ponderacionprecios (codigo,precio)  VALUES ('$codigo',$precio)";
    await _executeQuery(query);
  }

  static Future<void> deletePrecioPonderado(String codigo, int precio) async {
    String query =
        "DELETE FROM ponderacionprecios WHERE codigo = '$codigo' AND idpreciosP = $precio";
    await _executeQuery(query);
  }

  static Future<void> updateProducto(Producto producto) async {
    String query =
        "UPDATE producto SET idGrupo = ${producto.idGrupo}, um = '${producto.um}', precioIndicidual = ${producto.precioIndividual}, cantidad = ${producto.cantidad}, nombre = '${producto.nombre}', nombrePersona = '${producto.nombrePersona}', fecha = '${producto.fecha}', precioPonderado = ${producto.precioPonderado}, tipo_de_cambio = ${producto.tipoDeCambio} WHERE codigo = '${producto.codigo}'";
    await _executeQuery(query);
  }

  static Future<void> deleteProducto(String codigo) async {
    String query = "DELETE FROM producto where codigo = '$codigo'";
    await _executeQuery(query);
  }

  static Future<List<Producto>> getAllProductoByGrupos(int idGrupo) async {
    Results results =
        await _executeQuery('SELECT * FROM producto WHERE idGrupo = $idGrupo');
    List<Producto> resultados = [];
    for (var row in results) {
      Producto p = Producto(
          nombrePersona: row.fields['nombrePersona'],
          fecha: row.fields['fecha'],
          nombre: row.fields['nombre'],
          codigo: row.fields['codigo'],
          precioPonderado: row.fields['precioPonderado'],
          idGrupo: idGrupo,
          um: row.fields['um'],
          precioIndividual: row.fields['precioIndicidual'],
          cantidad: row.fields['cantidad'],
          tipoDeCambio: row.fields['tipo_de_cambio'],
          idPuntodeVenta: row.fields['id_tipo_de_venta']);

      resultados.add(p);
    }
    return resultados;
  }

  static Future<void> addMovimietoDone(String cdoigo, int cantidad,
      String tipoMovimiento, String destino) async {
    DateTime fecha = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(fecha);
    String query =
        "INSERT INTO movimientosdone (cantidad,done,fecha,codigo,tipoMvimiento,destino) VALUES ($cantidad,0,'$formattedDate','$cdoigo','$tipoMovimiento','$destino')";
    await _executeQuery(query);
  }

  static actualizarExistencia(Map<String, int> codigos) async {
    for (var element in codigos.keys) {
      String query =
          "UPDATE producto SET cantidad = cantidad - ${codigos[element]} WHERE codigo = '$element'";
      await _executeQuery(query);
      query = "UPDATE movimientosdone SET done = 1 WHERE codigo = '$element'";
      await _executeQuery(query);
    }
  }

//------------------------------------------------------------------------------------------

//----------------------------Monedas-------------------------------------------------------
  static Future<List<String>> getAlltiposMonedas() async {
    Results results = await _executeQuery('SELECT * FROM tipodecambio');
    List<String> resultados = [];
    for (var row in results) {
      resultados.add(row.fields['moneda']);
    }
    return resultados;
  }

  static Future<void> insertModificacionTipoCambio(Moneda m,String persona) async {
    DateTime d = DateTime.now();
  String formattedDate = DateFormat('dd/MM/yyyy').format(d);
    String query =
        "INSERT INTO modtcambio (idMoneda,fecha,cambio,persona)  VALUES ('${m.idTipoCambio}','$formattedDate,${m.cambio}',${m.cambio},'$persona')";
    await _executeQuery(query);
  }

  static Future<void> updateTipoCambio(Moneda m, int newCmabio) async {
    String query =
        "UPDATE tipodecambio SET cambio = $newCmabio  WHERE idTipoDeCambio = ${m.idTipoCambio}";
    await _executeQuery(query);
  }

  static Future<List<Modificacion>> getAlltiposMOdificaciones() async {
    Results results = await _executeQuery('SELECT * FROM modtcambio');
    List<Modificacion> resultados = [];
    for (var row in results) {
      Results results2 = await _executeQuery(
          'SELECT moneda FROM tipodecambio WHERE idTipoDeCambio = ${row.fields['idMoneda']}');

      resultados.add(Modificacion(
          persona: row.fields['persona'],
          cambio: row.fields['cambio'],
          fecha: row.fields['fecha'],
          moneda: results2.first.fields['moneda']));
    }
    return resultados;
  }

  static Future<List<Moneda>> getAlltiposMonedasClass() async {
    Results results = await _executeQuery('SELECT * FROM tipodecambio');
    List<Moneda> resultados = [];
    for (var row in results) {
      resultados.add(Moneda(
          cambio: row.fields['cambio'],
          moneda: row.fields['moneda'],
          idTipoCambio: row.fields['idTipoDeCambio']));
    }
    return resultados;
  }

  static Future<List<MovimientoToDo>> getAllMovimeintoToDo(int bool) async {
    List<MovimientoToDo> movimientosToDo = [];
    String query = "SELECT * FROM movimientosdone WHERE done = $bool";
    Results results = await _executeQuery(query);
    for (var element in results) {
      movimientosToDo.add(MovimientoToDo(
          cantidad: element.fields['cantidad'],
          codigo: element.fields['codigo'],
          done: element.fields['done'] == 0,
          fecha: element.fields['fecha'],
          destino: element.fields['destino'],
          idMovimientoDone: element.fields['idMoviemietnoDone'],
          tipoMovimiento: element.fields['tipoMvimiento']));
    }
    return movimientosToDo;
  }

  static Future<List<String>> getAllTiposMovimientos() async {
    List<String> tiposMovimiento = [];
    String query = "SELECT * FROM tiposmovimiento";
    Results results = await _executeQuery(query);
    for (var element in results) {
      tiposMovimiento.add(element.fields['movimiento']);
    }
    return tiposMovimiento;
  }

  static Future<List<Producto>> getAllMovimietnoByCodigo(int bool) async {
    List<MovimientoToDo> mvoimientosToDo = await getAllMovimeintoToDo(bool);
    List<Producto> producto = [];
    for (var element1 in mvoimientosToDo) {
      String query = "SELECT * FROM producto WHERE codigo='${element1.codigo}'";
      Results results = await _executeQuery(query);
      for (var element in results) {
        producto.add(Producto(
            fecha: element.fields['fecha'],
            nombrePersona: element.fields['nombrePersona'],
            nombre:
                '${element.fields['nombre']}\nTipo de Movimiento: ${element1.tipoMovimiento}\nDestino: ${element1.destino}',
            codigo: element1.codigo,
            idGrupo: element.fields['idGrupo'],
            um: element.fields['um'],
            precioIndividual: element.fields['precioIndicidual'],
            cantidad: element1.cantidad,
            cantidadRest: bool == 0
                ? element.fields['cantidad'] - element1.cantidad
                : element.fields['cantidad']));
      }
    }
    return producto;
  }

  static agregarTipoMovimiento(String tipoMovimiento) async {
    String query =
        "INSERT INTO tiposmovimiento (movimiento) VALUES ('$tipoMovimiento')";
    await _executeQuery(query);
  }

  static agregarMoneda(String newUnit, int tipocambio) async {
    String query =
        "INSERT INTO tipodecambio (moneda,cambio) VALUES ('$newUnit',$tipocambio)";
    await _executeQuery(query);
  }

//------------------------------------------------------------------------------------------
  static Future<List<String>> getAllPersonas() async {
    List<String> personas = [];
    String query = "SELECT * FROM personas";
    Results results = await _executeQuery(query);
    for (var persona in results) {
      personas.add(persona.fields['persona']);
    }
    return personas;
  }

  static agregarPersona(String newUnit) async {
    String query = "INSERT INTO personas (persona) VALUES ('$newUnit')";
    await _executeQuery(query);
  }

  static Future<List<Producto>> cargarEntradas() async {
    List<Producto> movimientos = [];
    String query = "SELECT * FROM movimientoentrada";
    Results results = await _executeQuery(query);
    for (var movimientoentrada in results) {
      movimientos.add(Producto(
          cantidad: movimientoentrada.fields['cantidad'],
          codigo: movimientoentrada.fields['codigoProducto'],
          fecha: movimientoentrada.fields['fecha'],
          nombre: movimientoentrada.fields['nombreProducto'],
          nombrePersona: movimientoentrada.fields['persona']));
    }
    return movimientos;
  }

  static getAllDestinos() async {
    Results results = await _executeQuery('SELECT * FROM destino');
    List<String> resultados = [];
    for (var row in results) {
      resultados.add(row.fields['destino']);
    }
    return resultados;
  }

  static Future<List<String>> getPuntosDeVenta() async {
    String query = "SELECT * FROM punto_de_venta";
    Results results = await _executeQuery(query);
    List<String> res = [];
    for (var element in results) {
      res.add(element.fields['nombre_punto_de_venta'].toString());
    }
    return res;
  }
}
