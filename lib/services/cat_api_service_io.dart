import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../models/breed.dart';
import '../models/cat_image.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class CatApiService {
  CatApiService({http.Client? client, String? apiKey})
    : apiKey = apiKey ?? const String.fromEnvironment('THE_CAT_API_KEY'),
      _client = client ?? _createSecureHttpClient();

  static const String _baseUrl = 'https://api.thecatapi.com/v1';
  static const String _baseUrlHttp = 'http://api.thecatapi.com/v1';
  final http.Client _client;
  final String? apiKey;

  static http.Client _createSecureHttpClient() {
    final httpClient = HttpClient();
    
    // Отключаем проверку сертификатов (для разработки)
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true; // Принимаем все сертификаты
    };
    
    // Устанавливаем таймауты
    httpClient.connectionTimeout = const Duration(seconds: 30);
    httpClient.idleTimeout = const Duration(seconds: 30);
    
    // Используем системный прокси
    httpClient.findProxy = HttpClient.findProxyFromEnvironment;
    
    return IOClient(httpClient);
  }

  Map<String, String> get _headers => {
    'accept': 'application/json',
    'User-Agent': 'cat_tinder/1.0',
    if (apiKey != null && apiKey!.isNotEmpty) 'x-api-key': apiKey!,
  };

  Future<CatImage> fetchRandomCat() async {
    try {
      // Пытаемся HTTPS
      return await _fetchRandomCatWithUrl(_baseUrl);
    } catch (e) {
      // HTTPS failed, try HTTP fallback
      try {
        // Fallback на HTTP
        return await _fetchRandomCatWithUrl(_baseUrlHttp);
      } catch (e2) {
        // HTTP fallback failed
        throw ApiException('Не удалось загрузить котика: $e2');
      }
    }
  }

  Future<CatImage> _fetchRandomCatWithUrl(String baseUrl) async {
    final uri = Uri.parse('$baseUrl/images/search?limit=1&has_breeds=1');
    // loading cat from uri
    
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

    // Если порода отсутствует, попробуем получить детальную информацию по изображению
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
      } catch (e) {
        // ignore detail fetch errors
      }

      // Если и это не дало результата, попытаемся сопоставить по reference_image_id из списка пород
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
      } catch (e) {
        // ignore reference_image_id lookup errors
      }
    }

    return cat;
  }

  Future<List<Breed>> fetchBreeds() async {
    try {
      return await _fetchBreedsWithUrl(_baseUrl);
    } catch (e) {
      // HTTPS failed for breeds, try HTTP
      try {
        return await _fetchBreedsWithUrl(_baseUrlHttp);
      } catch (e2) {
        // HTTP fallback failed for breeds
        throw ApiException('Не удалось получить список пород: $e2');
      }
    }
  }

  Future<List<Breed>> _fetchBreedsWithUrl(String baseUrl) async {
    final uri = Uri.parse('$baseUrl/breeds');
    // loading breeds from uri
    
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
