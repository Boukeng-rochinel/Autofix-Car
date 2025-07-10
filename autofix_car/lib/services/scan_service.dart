// lib/services/scan_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import '../models/scan_data.dart'; // Import ScanData model
import '../services/base_service.dart'; // Import BaseService for authenticated calls

final String kBaseUrl = dotenv.env['BASE_URL'] ?? 'http://fallback.url';

class ScanService {
  // Get all previous scan entries for the authenticated user
  static Future<List<ScanData>> getMyScans() async {
    final response = await BaseService.makeAuthenticatedRequest((
      idToken,
    ) async {
      final url = Uri.parse('$kBaseUrl/scans'); // Assuming a /scans endpoint
      return await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map(
            (jsonItem) =>
                ScanData.fromJson({'id': jsonItem['id'], ...jsonItem}),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to fetch scans: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Create a new scan entry (if backend expects this)
  // Often, this is part of the 'history' creation process
  static Future<ScanData> createScan(ScanData scan) async {
    final response = await BaseService.makeAuthenticatedRequest((
      idToken,
    ) async {
      final url = Uri.parse(
        '$kBaseUrl/scans',
      ); // Assuming a /scans endpoint for creation
      return await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode(scan.toJson()),
      );
    });

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return scan.copyWith(id: responseData['id'] as String?);
    } else {
      throw Exception(
        'Failed to create scan: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // You might want update/delete operations for scans here as well

  // Gemini Icon Detection
  static Future<Map<String, dynamic>?> detectGeminiIcon(String imagePath) async {
    final String? geminiApiKey = dotenv.env['GEMINI_API_KEY'];
    if (geminiApiKey == null) {
      throw Exception('Gemini API key not found in .env');
    }
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=$geminiApiKey');
    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Image
              }
            },
            {
              "text": "Detect and describe any icons or symbols in this image. Return the icon name and confidence if possible."
            }
          ]
        }
      ]
    });
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse Gemini response for icon detection result
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return { 'description': text };
      }
      return null;
    } else {
      throw Exception('Gemini icon detection failed: \\n${response.statusCode} - ${response.body}');
    }
  }
}
