class Moneda {
  int? idTipoCambio;
  String? moneda;
  double? cambio;
  String? persona;
  Moneda({this.idTipoCambio, this.moneda, this.cambio, this.persona});

  Map<String, dynamic> toJson() {
    return {
      'idTipoCambio': idTipoCambio,
      'moneda': moneda,
      'cambio': cambio,
      'persona': persona,
    };
  }
}
