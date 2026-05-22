import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../books/domain/entities/book_entity.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<BookEntity>>> getFavorites();
  Future<Either<Failure, Unit>> addFavorite(BookEntity book);
  Future<Either<Failure, Unit>> removeFavorite(String bookId);
  Future<Either<Failure, bool>> isFavorite(String bookId);
}
