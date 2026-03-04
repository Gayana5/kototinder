import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/breed.dart';
import '../../domain/entities/cat_image.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class CatApiService {
  CatApiService({http.Client? client, String? apiKey})
    : apiKey = apiKey ?? const String.fromEnvironment('THE_CAT_API_KEY'),
      _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.thecatapi.com/v1';
  static const String _baseUrlHttp = 'http://api.thecatapi.com/v1';
  final http.Client _client;
  final String? apiKey;

  Map<String, String> get _headers {
    final key = apiKey;
    return {
      'accept': 'application/json',
      'User-Agent': 'cat_tinder/1.0',
      if (key != null && key.isNotEmpty) 'x-api-key': key,
    };
  }

  Future<CatImage> fetchRandomCat() async {
    try {
      return await _fetchRandomCatWithUrl(_baseUrl);
    } catch (e) {
      try {
        return await _fetchRandomCatWithUrl(_baseUrlHttp);
      } catch (e2) {
        throw ApiException('Не удалось загрузить котика: $e2');
      }
    }
  }

  Future<CatImage> _fetchRandomCatWithUrl(String baseUrl) async {
    final uri = Uri.parse('$baseUrl/images/search?limit=1&has_breeds=1');

    final response = await _client.get(uri, headers: _headers).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('Таймаут подключения');
      },
    );

    if (response.statusCode != 200) {
      throw ApiException(
        'Не удалось загрузить котика (код ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    if (decoded.isEmpty) {
      throw ApiException('Котики закончились, попробуйте еще раз позже.');
    }
    final first = decoded.first as Map<String, dynamic>;
    final cat = CatImage.fromJson(first);
    if (cat.url.isEmpty) {
      throw ApiException('Ответ без изображения. Попробуйте обновить.');
    }

    // web: попробуем получить detail endpoint, но без dart:io
    if (cat.breed == null) {
      try {
        final detailUri = Uri.parse('$baseUrl/images/${cat.id}');
        final detailResp = await _client.get(detailUri, headers: _headers).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw TimeoutException('Таймаут при получении деталей изображения'),
        );
        if (detailResp.statusCode == 200) {
          final detailJson = jsonDecode(detailResp.body) as Map<String, dynamic>;
          final breeds = (detailJson['breeds'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((m) => Breed.fromJson(m))
              .toList();
          if (breeds != null && breeds.isNotEmpty) {
            return CatImage(id: cat.id, url: cat.url, breed: breeds.first);
          }
        }
      } catch (_) {
        // ignore
      }

      try {
        final allBreeds = await fetchBreeds();
        final matched = allBreeds.firstWhere(
          (b) => b.referenceImageId == cat.id,
          orElse: () => const Breed(
            id: '',
            name: '',
            description: '',
            temperament: '',
            origin: '',
            lifeSpan: '',
            weightImperial: '',
            adaptability: 0,
            intelligence: 0,
            affectionLevel: 0,
            energyLevel: 0,
          ),
        );
        if (matched.id.isNotEmpty) {
          return CatImage(id: cat.id, url: cat.url, breed: matched);
        }
      } catch (_) {
        // ignore
      }
    }

    return cat;
  }

  Future<List<Breed>> fetchBreeds() async {
    try {
      return await _fetchBreedsWithUrl(_baseUrl);
    } catch (e) {
      try {
        return await _fetchBreedsWithUrl(_baseUrlHttp);
      } catch (e2) {
        throw ApiException('Не удалось получить список пород: $e2');
      }
    }
  }

  Future<List<Breed>> _fetchBreedsWithUrl(String baseUrl) async {
    final uri = Uri.parse('$baseUrl/breeds');

    final response = await _client.get(uri, headers: _headers).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('Таймаут подключения');
      },
    );

    if (response.statusCode != 200) {
      throw ApiException(
        'Не удалось получить список пород (код ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Breed.fromJson)
        .where((breed) => breed.name.isNotEmpty)
        .toList();
  }
}
