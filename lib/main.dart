import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa o Riverpod
import 'screens/home_screen.dart';

void main() {
  runApp(
    const ProviderScope( // ProviderScope substitui MultiProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyHomePage(), // Atualize para a nova HomePage que usa Riverpod
    );
  }
}
