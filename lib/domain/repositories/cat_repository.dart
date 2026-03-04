import '../entities/breed.dart';
import '../entities/cat_image.dart';
import '../usecases/result.dart';

abstract class CatRepository {
  Future<Result<CatImage>> fetchRandomCat();
  Future<Result<List<Breed>>> fetchBreeds();
}
