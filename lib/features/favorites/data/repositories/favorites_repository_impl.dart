import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;
  const FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<BookEntity>>> getFavorites() async {
    try {
      final favorites = localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Cache error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addFavorite(BookEntity book) async {
    try {
      await localDataSource.addFavorite(book);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Failed to add favorite'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite(String bookId) async {
    try {
      await localDataSource.removeFavorite(bookId);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Failed to remove favorite'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String bookId) async {
    try {
      final result = localDataSource.isFavorite(bookId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Cache error'));
    }
  }
}
