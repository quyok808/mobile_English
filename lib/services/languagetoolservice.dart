import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feedback_model.dart';

class WritingLanguageToolService {
  final String apiUrl = 'https://api.languagetoolplus.com/v2/check';

  /// Kiểm tra ngữ pháp bằng LanguageTool API
  Future<List<FeedbackModel>> checkGrammar(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': text, 'language': 'en'}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final matches = result['matches'] as List;
        return matches.map((e) => FeedbackModel.fromJson(e)).toList();
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
