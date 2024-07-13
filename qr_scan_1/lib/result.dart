// ignore_for_file: deprecated_member_use, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:qr_scan_1/Analysis.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  final String qrCodeContent;

  const ResultScreen({Key? key, required this.qrCodeContent}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String resultMessage = 'Waiting for response...'; // Default message

  @override
  void initState() {
    super.initState();
    // Call the method to send URL to Flask when the screen initializes
    sendUrlToFlask();
  }

  Future<void> sendUrlToFlask() async {
    String modifiedUrl = widget.qrCodeContent;
    if (!widget.qrCodeContent.startsWith('http://') &&
        !widget.qrCodeContent.startsWith('https://')) {
      modifiedUrl = 'http://' + widget.qrCodeContent;
    }

    final response = await http.post(
      Uri.parse(
          'http://192.168.1.7:7000/qr_scan_1/result.dart'), // Update with your Flask server IP
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'url': modifiedUrl,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        // Parse the JSON response
        Map<String, dynamic> analysisResults = json.decode(response.body);

        // Update the result message based on the analysis results
        resultMessage = analysisResults['message'];
      });
    } else {
      setState(() {
        resultMessage = 'Failed to send URL to Flask.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Code Result',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Color.fromARGB(255, 241, 241, 241),
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scanned Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.qrCodeContent,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                resultMessage,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "Open sans"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String modifiedUrl = widget.qrCodeContent;
                  if (!widget.qrCodeContent.startsWith('http://') &&
                      !widget.qrCodeContent.startsWith('https://')) {
                    modifiedUrl = 'http://' + widget.qrCodeContent;
                  }
                  launch(modifiedUrl);
                },
                child: Text('Open URL in Browser'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnalysisScreen(
                        qrCodeContent: widget.qrCodeContent,
                      ),
                    ),
                  );
                },
                child: Text('View Analysis'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
