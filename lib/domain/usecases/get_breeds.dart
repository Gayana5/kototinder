import '../entities/breed.dart';
import '../repositories/cat_repository.dart';
import 'result.dart';

class GetBreedsUseCase {
  GetBreedsUseCase(this._repository);

  final CatRepository _repository;

  Future<Result<List<Breed>>> call() => _repository.fetchBreeds();
}
