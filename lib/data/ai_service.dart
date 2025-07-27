import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // 🔐 Replace this with your OpenRouter API key
  static const _apiKey = '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';

  // 🌐 OpenRouter endpoint
  static const _endpoint = 'https://openrouter.ai/api/v1/chat/completions';

  // 🧠 Choose your model (can be gpt-3.5, mistral, etc.)
  static const _model = 'openai/gpt-3.5-turbo';

  // 🚀 Main AI Call Function
  static Future<String> getBotReply(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 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',
          'HTTP-Referer': 'https://campus-companion.app', // optional, use your site if deployed
          'X-Title': 'Campus Companion', // app name
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful and friendly AI assistant for college students, answering campus-related queries clearly and kindly.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return "⚠️ AI error ${response.statusCode}: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "❌ Failed to connect to AI: $e";
    }
  }
}
