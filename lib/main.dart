import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';


void main() => runApp(CampusCompanionApp());

class CampusCompanionApp extends StatefulWidget {
  @override
  State<CampusCompanionApp> createState() => _CampusCompanionAppState();
}

class _CampusCompanionAppState extends State<CampusCompanionApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: ChatScreen(
        isDarkMode: isDarkMode,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}
