import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/usecases/get_books_usecase.dart';
import 'book_list_event.dart';
import 'book_list_state.dart';

class BookListBloc extends Bloc<BookListEvent, BookListState> {
  final GetBooksUseCase getBooksUseCase;

  BookListBloc({required this.getBooksUseCase})
      : super(const BookListInitial()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<SearchBooksEvent>(_onSearchBooks);
    on<LoadMoreBooksEvent>(_onLoadMoreBooks);
    on<RefreshBooksEvent>(_onRefreshBooks);
  }

  Future<void> _onFetchBooks(
    FetchBooksEvent event,
    Emitter<BookListState> emit,
  ) async {
    emit(const BookListLoading());
    await _loadBooks(emit, query: event.query, startIndex: 0, page: 0);
  }

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<BookListState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      add(const FetchBooksEvent());
      return;
    }
    emit(const BookListLoading());
    await _loadBooks(emit, query: event.query.trim(), startIndex: 0, page: 0);
  }

  Future<void> _onLoadMoreBooks(
    LoadMoreBooksEvent event,
    Emitter<BookListState> emit,
  ) async {
    final current = state;
    if (current is! BookListLoaded ||
        current.hasReachedMax ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.currentPage + 1;
    final result = await getBooksUseCase(
      GetBooksParams(
        query: current.currentQuery,
        startIndex: nextPage * ApiConstants.defaultMaxResults,
      ),
    );

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (newBooks) {
        if (newBooks.isEmpty) {
          emit(current.copyWith(hasReachedMax: true, isLoadingMore: false));
        } else {
          emit(BookListLoaded(
            books: [...current.books, ...newBooks],
            hasReachedMax: newBooks.length < ApiConstants.defaultMaxResults,
            currentQuery: current.currentQuery,
            currentPage: nextPage,
          ));
        }
      },
    );
  }

  Future<void> _onRefreshBooks(
    RefreshBooksEvent event,
    Emitter<BookListState> emit,
  ) async {
    final query = state is BookListLoaded
        ? (state as BookListLoaded).currentQuery
        : ApiConstants.defaultQuery;
    emit(const BookListLoading());
    await _loadBooks(emit, query: query, startIndex: 0, page: 0);
  }

  Future<void> _loadBooks(
    Emitter<BookListState> emit, {
    required String query,
    required int startIndex,
    required int page,
  }) async {
    final result = await getBooksUseCase(
      GetBooksParams(query: query, startIndex: startIndex),
    );

    result.fold(
      (failure) => emit(BookListError(failure.message)),
      (books) => emit(BookListLoaded(
        books: books,
        hasReachedMax: books.length < ApiConstants.defaultMaxResults,
        currentQuery: query,
        currentPage: page,
      )),
    );
  }
}
