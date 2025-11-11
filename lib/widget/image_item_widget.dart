import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_search/model/image_model.dart';
import 'package:image_search/provider/image_provider.dart';
import 'package:provider/provider.dart';

class ImageItemWidget extends StatelessWidget{
  final ImageModel image;

  const ImageItemWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageStateProvider>(context, listen: false);
    return GestureDetector(
      onTap: (){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미지: ${image.displaySiteName}')),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 이미지 표시
          CachedNetworkImage(
            imageUrl: image.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
          ),
          // 이미지 출처 표시
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                image.displaySiteName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // 즐겨찾기 버튼
          Positioned(
            top: 4,
            right: 4,
            child: Consumer<ImageStateProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  icon: Icon(
                    image.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: image.isFavorite ? Colors.red : Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    provider.toggleFavorite(image);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}