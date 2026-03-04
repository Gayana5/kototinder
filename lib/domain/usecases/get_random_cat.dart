import '../entities/cat_image.dart';
import '../repositories/cat_repository.dart';
import 'result.dart';

class GetRandomCatUseCase {
  GetRandomCatUseCase(this._repository);

  final CatRepository _repository;

  Future<Result<CatImage>> call() => _repository.fetchRandomCat();
}
