import 'breed.dart';

class CatImage {
  const CatImage({required this.id, required this.url, this.breed});

  final String id;
  final String url;
  final Breed? breed;

  factory CatImage.fromJson(Map<String, dynamic> json) {
    final breeds = (json['breeds'] as List<dynamic>?)
        ?.whereType<Map<String, dynamic>>()
        .map(Breed.fromJson)
        .toList();
    return CatImage(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      breed: breeds != null && breeds.isNotEmpty ? breeds.first : null,
    );
  }
}
