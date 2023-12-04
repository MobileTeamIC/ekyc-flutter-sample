import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogScreen extends StatelessWidget {
  final Map<String, dynamic> json;

  const LogScreen({
    Key? key,
    required this.json,
  }) : super(key: key);

  bool get shouldShowCopyAll => json.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hiển thị kết quả',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          shouldShowCopyAll
              ? TextButton(
                  onPressed: () {
                    _copyClipboard(json['INFO_RESULT']);
                    _copyClipboard(json['LIVENESS_CARD_FRONT_RESULT']);
                    _copyClipboard(json['LIVENESS_CARD_REAR_RESULT']);
                    _copyClipboard(json['COMPARE_RESULT']);
                    _copyClipboard(json['LIVENESS_FACE_RESULT']);
                    _copyClipboard(json['MASKED_FACE_RESULT']);
                  },
                  child: const Text(
                    'Copy All',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : const SizedBox.shrink(),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildLogItem(
            title: 'OCR',
            content: json['INFO_RESULT'],
          ),
          _buildLogItem(
            title: 'Liveness Card Front',
            content: json['LIVENESS_CARD_FRONT_RESULT'],
          ),
          _buildLogItem(
            title: 'Liveness Card Rear',
            content: json['LIVENESS_CARD_REAR_RESULT'],
          ),
          _buildLogItem(
            title: 'Compare',
            content: json['COMPARE_RESULT'],
          ),
          _buildLogItem(
            title: 'Liveness Face',
            content: json['LIVENESS_FACE_RESULT'],
          ),
          _buildLogItem(
            title: 'Mask Face',
            content: json['MASKED_FACE_RESULT'],
          ),
        ],
      ),
    );
  }

  _copyClipboard(String? content) async {
    if (content != null && content.trim().isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: content));
    }
  }

  Widget _buildLogItem({required String title, String? content}) {
    return content != null && content.trim().isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(24, 214, 150, 1),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    jsonDecode(content)['logID'] != null
                        ? TextButton(
                            onPressed: () =>
                                _copyClipboard(jsonDecode(content)['logID']),
                            child: const Text(
                              'Copy LogId',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : const SizedBox.shrink(),
                    TextButton(
                      onPressed: () => _copyClipboard(content),
                      child: const Text(
                        'Sao chép',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(content),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
