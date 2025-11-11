class ImageModel {
  // API 응답 데이터
  final String thumbnailUrl;
  final String imageUrl;
  final String displaySiteName;

  bool isFavorite;

  ImageModel({
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.displaySiteName,
    this.isFavorite = false,
  });

  // API json 응답을 Dart로 변환
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
        thumbnailUrl: json['thumbnail_url'] ?? '',
        imageUrl: json['image_url'] ?? '',
        displaySiteName: json['display_sitename'] ?? '출처 정보 없음'
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'thumbnailUrl': thumbnailUrl,
      'imageUrl': imageUrl,
      'displaySiteName': displaySiteName,
      'isFavorite' : isFavorite ? 1 : 0,
    };
  }
}