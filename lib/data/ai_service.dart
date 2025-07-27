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
          'Authorization': 'Bearer $_apiKey',
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
