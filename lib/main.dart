import 'package:dashtoon_web_app/screens/comic_panel.dart';
import 'package:dashtoon_web_app/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashtoon_web_app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        ComicPanel.routeName: (context) => const ComicPanel(),
      },
      home: HomePage(),
    );
  }
}
