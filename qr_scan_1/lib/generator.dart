// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class GenerateQR extends StatefulWidget {
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  TextEditingController urlController = TextEditingController();
  Color qrColor = Colors.black;
  bool generateClicked = false;

  void changeColor(Color color) {
    setState(() {
      qrColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Generate QR Code            ",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Color.fromARGB(255, 241, 241, 241),
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
        )),
        titleSpacing: 0,
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (generateClicked && urlController.text.isNotEmpty)
              QrImageView(
                data: urlController.text,
                version: QrVersions.auto,
                size: 200,
                foregroundColor: qrColor,
              ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: urlController,
                decoration: InputDecoration(
                  hintText: "Enter your data",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey, // Change the color of the hint text
                    fontSize: 16, // Change the font size of the hint text
                    fontStyle: FontStyle.normal, // Italicize the hint text
                  ),
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Enter your data',
                  labelStyle: GoogleFonts.poppins(
                    color: const Color.fromARGB(
                        255, 108, 36, 121), // Change color if needed
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  generateClicked = true;
                });
              },
              child: Text('Generate QR Code',
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 122, 40,
                        136), // Ensure the text color is appropriate for your button color
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pick a color',
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 0, 0,
                                0), // Ensure the text color is appropriate for your button color
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: qrColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Pick a color',
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 124, 38,
                        139), // Ensure the text color is appropriate for your button color
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            SizedBox(height: 10),
            Text('Selected Color:',
                style: GoogleFonts.poppins(
                  color: Colors
                      .black87, // Ensure the text color is appropriate for your button color
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 5),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: qrColor,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
