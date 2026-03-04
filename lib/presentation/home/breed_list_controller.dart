import 'package:flutter/foundation.dart';

import '../../domain/entities/breed.dart';
import '../../domain/usecases/get_breeds.dart';

class BreedListController extends ChangeNotifier {
  BreedListController(this._getBreeds);

  final GetBreedsUseCase _getBreeds;

  List<Breed> _breeds = [];
  String _query = '';
  bool _isLoading = false;
  String? _error;

  List<Breed> get breeds {
    if (_query.isEmpty) {
      return _breeds;
    }
    final lower = _query.toLowerCase();
    return _breeds
        .where((breed) =>
            breed.name.toLowerCase().contains(lower) ||
            breed.origin.toLowerCase().contains(lower) ||
            breed.temperament.toLowerCase().contains(lower))
        .toList();
  }
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get query => _query;

  Future<void> loadBreeds() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getBreeds();
    if (result.isSuccess && result.data != null) {
      _breeds = result.data ?? [];
    } else {
      _error = result.error ?? 'Не удалось загрузить список пород.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateQuery(String value) {
    _query = value.trim();
    notifyListeners();
  }
}
