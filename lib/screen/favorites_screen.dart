import 'package:flutter/material.dart';
import 'package:image_search/provider/image_provider.dart';
import 'package:image_search/widget/image_item_widget.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ImageStateProvider>();
    if(provider.favorites.isEmpty){
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text('즐겨찾기에 저장된 이미지가 없습니다.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text('검색 탭에서 마음에 드는 이미지를 저장해보세요.', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 1.0,
      ),
      itemCount: provider.favorites.length,
      itemBuilder: (context, index) {
        final imageModel = provider.favorites[index];
        return ImageItemWidget(image: imageModel);
      },
    );
  }
}