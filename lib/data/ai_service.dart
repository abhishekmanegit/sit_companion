import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const _apiKey = 'AIzaSyAxPYZU8_kErjoi0YNeT0Xv-goh578CO18'; // Replace with your actual Gemini API key
  static const _endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> getBotReply(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': 'You are a helpful college assistant bot. Answer the following question: $prompt'
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract the response text from Gemini API response structure
        final candidates = data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          if (parts.isNotEmpty) {
            return parts[0]['text'].trim();
          }
        }
        return "Sorry, I couldn't generate a response.";
      } else {
        return "Sorry, I'm having trouble reaching my AI brain 🧠 right now. Status: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
