import 'dart:convert';

import 'package:image_search/model/image_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String API_KEY = '0ce383048c481acadc7d46e2ad3c40fe';
  static const String BASE_URL = 'https://dapi.kakao.com/v2/search/image';
  static final Map<String, String> headers = {
    'Authorization': 'KakaoAK $API_KEY',
  };

  Future<List<ImageModel>> fetchImages(String query) async {
    if(query.isEmpty) {
      return [];
    }

    final uri = Uri.parse('$BASE_URL?query=$query&size=30');

    try {
      final response = await http.get(uri, headers: headers);
      
      if(response.statusCode == 200){
       final String jsonString = utf8.decode(response.bodyBytes);
       final Map<String, dynamic> jsonResponse = json.decode(jsonString);
       final List<dynamic> documents = jsonResponse['documents'] ?? [];

       return documents.map((json) => ImageModel.fromJson(json)).toList();
      }else{
        print('API 호출 실패: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        throw Exception('이미지 로드에 실패했습니다. (상태 코드: ${response.statusCode})');
      }
    } catch(e) {
      print('네트워크 오류 발생: $e');
      throw Exception('네트워크 연결 또는 서버 오류가 발생했습니다.');
    }
  }
}