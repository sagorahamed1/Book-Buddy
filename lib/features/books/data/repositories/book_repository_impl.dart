import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;
  const BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BookEntity>>> fetchBooks({
    required String query,
    required int startIndex,
    int maxResults = 10,
  }) async {
    try {
      final books = await remoteDataSource.fetchBooks(
        query: query,
        startIndex: startIndex,
        maxResults: maxResults,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred.'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error occurred.'));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message ?? 'Request timed out.'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
