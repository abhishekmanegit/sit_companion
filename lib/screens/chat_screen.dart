import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';
import '../data/faq_data.dart';
import '../data/ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isBotTyping = false;

  void _handleSend() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add(Message(text: input, isUser: true));
      _isBotTyping = true;
    });

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 500), () async {
      String reply;

      // Try smart matching
      reply = getSmartMatch(input.toLowerCase());

      // If still no match, use AI
      if (reply.isEmpty) {
        reply = await AIService.getBotReply(input);
      }

      setState(() {
        _messages.add(Message(text: reply, isUser: false));
        _isBotTyping = false;
      });
    });
  }

  String getSmartMatch(String input) {
    if (input.contains("wifi")) {
      return faqData["what is the wifi password"]!;
    } else if (input.contains("placement")) {
      return faqData["where is the placement cell"]!;
    } else if (input.contains("fees") || input.contains("fee")) {
      return faqData["last date to pay fees"]!;
    } else if (input.contains("hod") || input.contains("head of")) {
      return faqData["who is the hod of cse"]!;
    } else if (input.contains("bonafide")) {
      return faqData["how to get bonafide certificate"]!;
    } else if (input.contains("cafeteria") || input.contains("canteen")) {
      return faqData["cafeteria timings"]!;
    }

    return ""; // nothing matched
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎓 Campus Companion")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubble(text: msg.text, isUser: msg.isUser);
              },
            ),
          ),
          if (_isBotTyping)
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Bot is typing...", style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask me anything...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSend,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
} 