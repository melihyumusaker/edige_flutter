// ignore_for_file: file_names, use_key_in_widget_constructors

import 'dart:io';

import 'package:edige/controllers/QRController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QRController qrController = Get.find<QRController>();
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: qrCodeScanPageAppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: MediaQuery.of(context).orientation == Orientation.portrait
                ? 5
                : 3,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Obx(() => qrController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenHeight * 0.02),
                    color: Colors.deepPurpleAccent,
                    child: Text(
                      result != null
                          ? Get.find<QRController>().realResponse.value
                          : 'QR kodu tarayın',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenHeight * 0.025,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
          ),
        ],
      ),
    );
  }

  AppBar qrCodeScanPageAppBar() {
    return AppBar(
      centerTitle: true,
      title:
          const Text('QR Kod Okuyucu', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        int userId = int.tryParse(result!.code ?? "") ?? 0;
        if (userId > 0) {
          final qrController = Get.find<QRController>();

          await qrController.saveStudentRecords(userId);
        }
      }
    });
  }
}
