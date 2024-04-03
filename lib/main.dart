import 'package:flutter/material.dart';
import 'package:note_app/homepage.dart';

main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      title: "note-app",
      home: const HomePage(),
    );
  }
}
