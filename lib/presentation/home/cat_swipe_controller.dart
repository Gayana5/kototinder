import 'package:flutter/foundation.dart';

import '../../domain/entities/cat_image.dart';
import '../../domain/usecases/get_random_cat.dart';

class CatSwipeController extends ChangeNotifier {
  CatSwipeController(this._getRandomCat);

  final GetRandomCatUseCase _getRandomCat;

  CatImage? _currentCat;
  bool _isLoading = false;
  String? _error;
  final List<CatImage> _likedCats = [];

  CatImage? get currentCat => _currentCat;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CatImage> get likedCats => List.unmodifiable(_likedCats);
  int get likes => _likedCats.length;

  Future<void> loadNextCat({bool liked = false}) async {
    if (_isLoading) {
      return;
    }
    if (liked) {
      final cat = _currentCat;
      if (cat != null && !_likedCats.any((c) => c.id == cat.id)) {
        _likedCats.add(cat);
      }
    }
    _currentCat = null;
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getRandomCat();
    if (result.isSuccess) {
      _currentCat = result.data;
    } else {
      _error = result.error;
    }
    _isLoading = false;
    notifyListeners();
  }

  void removeLiked(CatImage cat) {
    _likedCats.removeWhere((c) => c.id == cat.id);
    notifyListeners();
  }

  void clearError() {
    _error = null;
  }
}
