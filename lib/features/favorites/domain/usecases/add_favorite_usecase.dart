import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../repositories/favorites_repository.dart';

class AddFavoriteUseCase implements UseCase<Unit, BookEntity> {
  final FavoritesRepository repository;
  const AddFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(BookEntity params) {
    return repository.addFavorite(params);
  }
}
