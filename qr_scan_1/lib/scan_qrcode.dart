// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scan_1/result.dart';
import 'package:google_fonts/google_fonts.dart';

class Scanqrcode extends StatefulWidget {
  const Scanqrcode({super.key});

  @override
  State<Scanqrcode> createState() => _ScanqrcodeState();
}

class _ScanqrcodeState extends State<Scanqrcode> {
  String qrResult = "Scanned Data will appear here";

  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.QR);
      if (!mounted) return;

      setState(() {
        this.qrResult = qrCode.toString();
      });
      //Navigate to the ResultScreen with the scanned QR code content
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(qrCodeContent: qrResult),
        ),
      );
    } on PlatformException {
      qrResult = "failed to scan";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '    QR code Scanner',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Color.fromARGB(255, 241, 241, 241),
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            '$qrResult',
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: scanQR,
            child: Text('Scan Code',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 129, 32,
                      32), // Ensure the text color is appropriate for your button color
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      )),
    );
  }
}
