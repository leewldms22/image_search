import 'package:flutter/material.dart';
import 'package:image_search/screen/favorites_screen.dart';
import 'package:image_search/screen/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Kakao 이미지 검색'),
            bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.search), text: '검색'),
                  Tab(icon: Icon(Icons.favorite), text: '즐겨찾기'),
                ],
            ),
          ),
          body: const TabBarView(
              children: [
                SearchScreen(),
                FavoritesScreen(),
              ],
          ),
        ),
    );
  }
}