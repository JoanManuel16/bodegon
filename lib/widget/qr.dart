import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeW extends StatelessWidget {
  const QRCodeW({
    Key? key,
    this.qrSize,
    required this.qrData,
  }) : super(key: key);

  final double? qrSize;

  final String qrData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        child: QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: qrSize,
      gapless: false,
    ));
  }
}