import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/favorites_repository.dart';

class RemoveFavoriteUseCase implements UseCase<Unit, String> {
  final FavoritesRepository repository;
  const RemoveFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String bookId) {
    return repository.removeFavorite(bookId);
  }
}
