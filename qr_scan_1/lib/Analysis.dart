// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class AnalysisScreen extends StatefulWidget {
  final String qrCodeContent;

  const AnalysisScreen({Key? key, required this.qrCodeContent})
      : super(key: key);

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String resultMessage = 'Waiting for response...'; // Default message
  bool isLoading = true;
  String urlResult = ''; // Declare urlResult here
  String analysisResult = ''; // Declare analysisResult here

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
          'http://0.0.0.0:7000/qr_scan_1/Analysis.dart'), // Update with your Flask server IP
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'url': modifiedUrl,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        // Parse the JSON response
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        resultMessage = jsonResponse['message']; // Store the message
        urlResult = jsonResponse['url']; // Store the URL
        // Check if jsonResponse['analysis_results'] is a String
        if (jsonResponse['analysis_results'] is String) {
          analysisResult = jsonResponse['analysis_results'];
        } else {
          // If it's a Map or List, stringify the JSON
          analysisResult = json.encode(jsonResponse['analysis_results']);
        }
      });
    } else {
      setState(() {
        isLoading = false;
        resultMessage =
            'Failed to send URL to Flask. Status code: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analysis Results',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Color.fromARGB(255, 241, 241, 241),
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading indicator
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    resultMessage,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 130, 26, 190),
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  // Show the message
                  Text(
                    urlResult,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 26, 190, 127),
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "RESULT :",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 180, 180, 180),
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ), // Show the URL
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <String>[
                        for (var entry in json.decode(analysisResult).entries)
                          '${entry.key}: ${entry.value}'
                      ].map((result) {
                        return ListTile(title: Text(result));
                      }).toList(),
                    ),
                  ), // Show the analysis results
                ],
              ), // Show result message
      ),
    );
  }
}
