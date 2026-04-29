import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class ComplimentService {
  static Future<Map<String, dynamic>> getCompliments(int page) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.compliments}?page=$page&per_page=10"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load compliments");
    }
  }

  static Future<void> generateCompliments(String theme, int total) async {
    final response = await http.post(
      Uri.parse(ApiConstants.generate),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "theme": theme,
        "total": total,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to generate compliments");
    }
  }
}
