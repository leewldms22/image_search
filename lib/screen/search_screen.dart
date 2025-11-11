import 'package:flutter/material.dart';
import 'package:image_search/provider/image_provider.dart';
import 'package:image_search/widget/image_item_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageStateProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: '검색어를 입력하세요.',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (query) => imageProvider.searchImages(query),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: (){
                  imageProvider.searchImages(_controller.text);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('검색'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildBody(imageProvider),
        ),
      ],
    );
  }

  Widget _buildBody(ImageStateProvider provider) {
    if(provider.isLoading){
      return const Center(child: CircularProgressIndicator());
    }

    if(provider.errorMessage.isNotEmpty){
      return Center(
        child: Text(
          provider.errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if(provider.searchResults.isEmpty) {
      return const Center(
        child: Text('검색 결과가 여기에 표시됩니다.', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
        itemCount: provider.searchResults.length,
        itemBuilder: (context, index) {
          final imageModel = provider.searchResults[index];
          return ImageItemWidget(image: imageModel);
        },
    );
  }
}