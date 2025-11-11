import 'package:flutter/material.dart';
import 'package:image_search/model/image_model.dart';
import 'package:image_search/service/api_service.dart';
import 'package:image_search/service/db_service.dart';

class ImageStateProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DbService _dbService = DbService.instance;

  // 상태변수
  List<ImageModel> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  List<ImageModel> _favorites = [];

  // getter
  List<ImageModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ImageModel> get favorites => _favorites;

  ImageStateProvider() {
    loadFavorites();
  }

  // 즐겨찾기 목록 로드
  Future<void> loadFavorites() async {
    _favorites = await _dbService.readAllFavorites();
    notifyListeners();
  }

  // 검색 기능
  Future<void> searchImages(String query) async {
    if(query.trim().isEmpty){
      _searchResults = [];
      _errorMessage = '검색어를 입력해 주세요.';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    try{
      final apiResults = await _apiService.fetchImages(query);

      for(var image in apiResults){
        image.isFavorite = await _dbService.isFavorite(image.imageUrl);
      }

      _searchResults = apiResults;

      if(_searchResults.isEmpty){
        _errorMessage = '검색 결과가 없습니다.';
      }
    }catch(e){
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(ImageModel image) async {
    image.isFavorite = !image.isFavorite;

    if(image.isFavorite){
      await _dbService.createFavorite(image);
    }else{
      await _dbService.deleteFavorite(image.imageUrl);
    }

    await loadFavorites();
  }
}