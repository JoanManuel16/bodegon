class Producto {
  String? codigo;
  int? idGrupo;
  String? um;
  int? idInventario;
  double? precioIndividual;
  int? cantidad;
  String? nombre;
  String? nombrePersona;
  String? fecha;
  int? cantidadRest;
  double? precioPonderado;

  Producto(
      {this.precioPonderado,
      this.cantidadRest,
      this.idInventario,
      this.fecha,
      this.nombrePersona,
      this.nombre,
      this.codigo,
      this.idGrupo,
      this.um,
      this.precioIndividual,
      this.cantidad});

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'idGrupo': idGrupo,
      'um': um,
      'idInventario': idInventario,
      'precioIndividual': precioIndividual,
      'cantidad': cantidad,
      'nombre': nombre,
      'nombrePersona': nombrePersona,
      'fecha': fecha
    };
  }
}
