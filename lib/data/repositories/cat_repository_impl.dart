import '../../domain/entities/breed.dart';
import '../../domain/entities/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';
import '../../domain/usecases/result.dart';
import '../datasources/cat_api_service.dart';

class CatRepositoryImpl implements CatRepository {
  CatRepositoryImpl(this._api);

  final CatApiService _api;

  @override
  Future<Result<CatImage>> fetchRandomCat() async {
    try {
      final cat = await _api.fetchRandomCat();
      return Result.success(cat);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Breed>>> fetchBreeds() async {
    try {
      final breeds = await _api.fetchBreeds();
      return Result.success(breeds);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
