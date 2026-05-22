import 'package:equatable/equatable.dart';
import '../../domain/entities/book_entity.dart';

abstract class BookListState extends Equatable {
  const BookListState();
}

class BookListInitial extends BookListState {
  const BookListInitial();

  @override
  List<Object> get props => [];
}

class BookListLoading extends BookListState {
  const BookListLoading();

  @override
  List<Object> get props => [];
}

class BookListLoaded extends BookListState {
  final List<BookEntity> books;
  final bool hasReachedMax;
  final String currentQuery;
  final int currentPage;
  final bool isLoadingMore;

  const BookListLoaded({
    required this.books,
    required this.hasReachedMax,
    required this.currentQuery,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  BookListLoaded copyWith({
    List<BookEntity>? books,
    bool? hasReachedMax,
    String? currentQuery,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return BookListLoaded(
      books: books ?? this.books,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [
        books,
        hasReachedMax,
        currentQuery,
        currentPage,
        isLoadingMore,
      ];
}

class BookListError extends BookListState {
  final String message;
  const BookListError(this.message);

  @override
  List<Object> get props => [message];
}
