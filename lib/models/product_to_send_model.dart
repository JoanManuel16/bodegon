import 'package:flutter_application_1/models/Pproducto.dart';

class ProductToSendModel extends Producto {
  String destino = "";

  ProductToSendModel(
      precioPonderado,
      cantidadRest,
      idInventario,
      fecha,
      nombrePersona,
      nombre,
      codigo,
      idGrupo,
      um,
      precioIndividual,
      cantidad,
      this.destino)
      : super(
            precioPonderado: precioPonderado,
            cantidadRest: cantidadRest,
            idInventario: idInventario,
            fecha: fecha,
            nombrePersona: nombrePersona,
            nombre: nombre,
            codigo: codigo,
            idGrupo: idGrupo,
            um: um,
            precioIndividual: precioIndividual,
            cantidad: cantidad);

  ProductToSendModel.fromProduct(Producto P, this.destino)
      : super(
            cantidad: P.cantidad,
            cantidadRest: P.cantidadRest,
            codigo: P.codigo,
            fecha: P.fecha,
            idGrupo: P.idGrupo,
            idInventario: P.idInventario,
            nombre: P.nombre,
            nombrePersona: P.nombrePersona,
            precioIndividual: P.precioIndividual,
            precioPonderado: P.precioPonderado,
            um: P.um);

  Map<String, dynamic> toJsonWithDestiny() {
    return {
      'codigo': codigo,
      'idGrupo': idGrupo,
      'um': um,
      'idInventario': idInventario,
      'precioIndividual': precioIndividual,
      'cantidad': cantidad,
      'nombre': nombre,
      'nombrePersona': nombrePersona,
      'fecha': fecha,
      'destino': destino
    };
  }
}
