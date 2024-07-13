import 'package:flutter/material.dart';
import 'package:qr_scan_1/generator.dart';
import 'package:qr_scan_1/scan_qrcode.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner and Generator',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Code Scanner and Generator',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Scanqrcode()));
                  });
                },
                child: Text(
                  'Scan Qr code',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color.fromARGB(255, 130, 26, 190),
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                )),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => GenerateQR()));
                });
              },
              child: Text(
                'Generate Qr code',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 100),
            Center(
                child: Text('Developed by Team Jaas',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ))),
            SizedBox(height: 20),
            Center(
                child: Text('© 2024 Jaas. All rights reserved.',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ))))
          ],
        ),
      ),
    );
  }
}
