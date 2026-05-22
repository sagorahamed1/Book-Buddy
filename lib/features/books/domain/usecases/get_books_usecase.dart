import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetBooksUseCase implements UseCase<List<BookEntity>, GetBooksParams> {
  final BookRepository repository;
  const GetBooksUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(GetBooksParams params) {
    return repository.fetchBooks(
      query: params.query,
      startIndex: params.startIndex,
      maxResults: params.maxResults,
    );
  }
}

class GetBooksParams extends Equatable {
  final String query;
  final int startIndex;
  final int maxResults;

  const GetBooksParams({
    required this.query,
    this.startIndex = 0,
    this.maxResults = ApiConstants.defaultMaxResults,
  });

  @override
  List<Object> get props => [query, startIndex, maxResults];
}
