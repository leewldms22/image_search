import 'package:flutter/material.dart';
import 'package:image_search/provider/image_provider.dart';
import 'package:image_search/screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => ImageStateProvider(),
        child: const ImageSearchApp(),
    ),
  );
}

class ImageSearchApp extends StatelessWidget {
  const ImageSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '이미지 검색 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
