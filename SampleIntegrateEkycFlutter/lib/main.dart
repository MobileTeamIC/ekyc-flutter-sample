import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleintegrateekyc/log_screen.dart';

void main() {
  runApp(const SampleIntegrateEkycApp());
}

class SampleIntegrateEkycApp extends StatelessWidget {
  const SampleIntegrateEkycApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integrate eKYC Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Tích hợp SDK VNPT eKYC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = const MethodChannel('flutter.sdk.ekyc/integrate');
  }

  Future<Map<String, dynamic>> _startEkycByNameMethod({required String methodName}) async {
    final json = await _channel.invokeMethod(methodName, {
      "access_token": "<ACCESS_TOKEN> including bearer",
      "token_id": "<TOKEN_ID>",
      "token_key": "<TOKEN_KEY>",
    });
    return jsonDecode(json);
  }

  _navigateToLog(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogScreen(json: json),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _buildButton(
              title: 'eKYC luồng đầy đủ',
              onPressed: () async {
                _navigateToLog(await _startEkycByNameMethod(methodName: "startEkycFull"));
              },
            ),
            _buildButton(
              title: 'Thực hiện OCR giấy tờ',
              onPressed: () async {
                _navigateToLog(
                    await _startEkycByNameMethod(methodName: "startEkycOcr"));
              },
            ),
            _buildButton(
              title: 'Thực hiện kiểm tra khuôn mặt',
              onPressed: () async {
                _navigateToLog(
                    await _startEkycByNameMethod(methodName: "startEkycFace"));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String title, VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FractionallySizedBox(
        widthFactor: 1.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(24, 214, 150, 1),
            elevation: 0,
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
