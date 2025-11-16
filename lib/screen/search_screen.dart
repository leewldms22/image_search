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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final provider = Provider.of<ImageStateProvider>(context, listen: false);
    if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9 && !provider.isLoading){
      provider.loadNextPage(_controller.text);
    }
  }

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
        controller: _scrollController,
        padding: const EdgeInsets.all(4.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1.0,
        ),
        itemCount: provider.searchResults.length + (provider.isPaginating ? 1: 0),
        itemBuilder: (context, index) {
          if(index == provider.searchResults.length){
            if(provider.isEnd){
              return const Center(child: Text('모든 결과를 로드했습니다.'));
            }
            return const Center(
              child: SizedBox(
                height: 30, width: 30,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            );
          }

          final imageModel = provider.searchResults[index];
          return ImageItemWidget(image: imageModel);
        },
    );
  }
}