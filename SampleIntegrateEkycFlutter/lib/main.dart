import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleintegrateekyc/log_screen.dart';
import 'package:sampleintegrateekyc/services/ekyc_method_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/ekyc_presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const MyHomePage(title: 'Tích hợp SDK VNPT eKYC'),
      ),
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
  final EkycMethodChannel _ekyc = const EkycMethodChannel();

  // You can source these from secure storage/config later per your environment
  static final String _accessToken = dotenv.env['ACCESS_TOKEN'] ?? '';
  static final String _tokenId = dotenv.env['TOKEN_ID'] ?? '';
  static final String _tokenKey = dotenv.env['TOKEN_KEY'] ?? '';
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  String _hashFrontOcr = '';

  @override
  void initState() {
    super.initState();
    _hashFrontOcr =  '';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Label HASH_FRONT_OCR_FROM_OCR_FRONT_RESULT
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Hash image front from OCR front result',
              ),
              onChanged: (value) => setState(() => _hashFrontOcr = value),
            ),
                ],
              ),
            ),
            Spacer(),
            _buildButton(
              title: 'eKYC luồng đầy đủ',
              onPressed: () async {
                try {
                  final config = EkycPresets.fullEkyc(
                    accessToken: _accessToken,
                    tokenId: _tokenId,
                    tokenKey: _tokenKey,
                    changeBaseUrl: baseUrl,
                  );
                  _navigateToLog(await _ekyc.startEkycFull(config));
                } on PlatformException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? ''),
                    ),
                  );
                }
              },
            ),
            _buildButton(
              title: 'Thực hiện OCR giấy tờ',
              onPressed: () async {
                try {
                  final config = EkycPresets.ocrOnly(
                    accessToken: _accessToken,
                    tokenId: _tokenId,
                    tokenKey: _tokenKey,
                  );
                  _navigateToLog(await _ekyc.startEkycOcr(config));
                } on PlatformException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? ''),
                    ),
                  );
                }
              },
            ),
            _buildButton(
              title: 'Thực hiện OCR chỉ mặt trước',
              onPressed: () async {
                try {
                  final config = EkycPresets.ocrFront(
                    accessToken: _accessToken,
                    tokenId: _tokenId,
                    tokenKey: _tokenKey,
                  );
                  _navigateToLog(await _ekyc.startEkycOcrFront(config));
                } on PlatformException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? ''),
                    ),
                  );
                }
              },
            ),
            _buildButton(
              title: 'Thực hiện OCR chỉ mặt sau',
              onPressed: () async {
                // With back-only flow, you must provide hash of front OCR
                try {
                  final config = EkycPresets.ocrBack(
                    accessToken: _accessToken,
                    tokenId: _tokenId,
                    tokenKey: _tokenKey,
                    hashFrontOcr: _hashFrontOcr,
                  );
                  _navigateToLog(await _ekyc.startEkycOcrBack(config));
                } on PlatformException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? ''),
                    ),
                  );
                }
              },
            ),
            _buildButton(
              title: 'Thực hiện kiểm tra khuôn mặt',
              onPressed: () async {
                try {
                  final config = EkycPresets.faceVerification(
                    accessToken: _accessToken,
                    tokenId: _tokenId,
                    tokenKey: _tokenKey,
                    hashImageCompare: _hashFrontOcr,
                  );
                  _navigateToLog(await _ekyc.startEkycFace(config));
                } on PlatformException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? ''),
                    ),
                  );
                }
              },
            ),
            _buildButton(
              title: 'Thực hiện quét QR code',
              onPressed: () async {
                try {
                  final config = EkycPresets.scanQRCode(
                    accessToken: _accessToken,
                    tokenId: _tokenId,
                    tokenKey: _tokenKey,
                  );
                  _navigateToLog(await _ekyc.startEkycScanQRCode(config));
                } on PlatformException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? ''),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
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
