import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_search/model/image_model.dart';
import 'package:http/http.dart' as http;

class ImageSearchResponse {
  final List<ImageModel> images;
  final bool isEnd;

  ImageSearchResponse({required this.images, required this.isEnd});
}

class ApiService {
  static const String API_KEY = '0ce383048c481acadc7d46e2ad3c40fe';
  static const String BASE_URL = 'https://dapi.kakao.com/v2/search';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      headers: {
        'Authorization': 'KakaoAK $API_KEY',
      },
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.bytes,
    ),
  );

  Future<ImageSearchResponse> fetchImages(String query, int page) async {
    if (query.isEmpty) {
      return ImageSearchResponse(images: [], isEnd: true);
    }

    final uri = Uri.parse('$BASE_URL?query=$query&size=30&page=$page');

    try {
      final response = await _dio.get(
        '/image',
        queryParameters: {
          'query': query,
          'size': 30,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final String jsonString = utf8.decode(response.data);
        final Map<String, dynamic> jsonResponse = json.decode(jsonString);
        final List<dynamic> documents = jsonResponse['documents'] ?? [];
        final Map<String, dynamic> meta = jsonResponse['meta'] ?? {};
        final bool isEnd = meta['is_end'] ?? true;

        final images = documents
            .map((json) => ImageModel.fromJson(json))
            .toList();

        return ImageSearchResponse(images: images, isEnd: isEnd);
      } else {
        throw Exception('이미지 로드에 실패했습니다. (상태 코드: ${response.statusCode})');
      }
    } on DioException catch (e){
      String errorMsg = 'API 통신 오류가 발생했습니다.';
      if(e.response != null){
        errorMsg = '서버 응답 오류: ${e.response!.statusCode}';
      }else{
        errorMsg = '네트워크 연결 오류: ${e.message}';
      }
      print(errorMsg);
      throw Exception(errorMsg);
    } catch(e) {
      throw Exception('알 수 없는 오류 발생: $e');
    }
  }
}