import 'package:flutter/material.dart';

void main() {
  runApp(_QRScannerState() as Widget);
}

class _QRScannerState extends State<QRScanneState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRScannerController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
  super.reassemble();
  if (Platform.isAndroid) {
  controller!.pauseCamera();
  } else if (Platform.isIOS) {
  controller!.resumeCamera();
  }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: Column(
  children: <Widget>[
  Expanded(
  flex: 5,
  child: QRScanner(
  key: qrKey,
  onQRScannerCreated: _onQRScannerCreated,
  ),
  ),
  Expanded(
  flex: 1,
  child: Center(
  child: (result != null)
  ? Text(
  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
      : Text('Scan a code'),
  ),
  )
  ],
  ),
  );
  }

  void _onQRScannerCreated(QRScannerController controller) {
  this.controller = controller;
  controller.scannedDataStream.listen((scanData) {
  setState(() {
  result = scanData;
  });
  });
  }

  @override
  void dispose() {
  controller?.dispose();
  super.dispose();
  }
  }
}