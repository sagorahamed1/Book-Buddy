import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase implements UseCase<List<BookEntity>, NoParams> {
  final FavoritesRepository repository;
  const GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) {
    return repository.getFavorites();
  }
}
