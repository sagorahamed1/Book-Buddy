import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book_entity.dart';

abstract class BookRepository {
  Future<Either<Failure, List<BookEntity>>> fetchBooks({
    required String query,
    required int startIndex,
    int maxResults,
  });
}
