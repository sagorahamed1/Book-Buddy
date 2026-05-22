import 'package:equatable/equatable.dart';
import '../../../books/domain/entities/book_entity.dart';

enum FavoritesStatus { initial, loading, loaded, error }

class FavoritesState extends Equatable {
  final List<BookEntity> favorites;
  final FavoritesStatus status;
  final String? errorMessage;

  const FavoritesState({
    this.favorites = const [],
    this.status = FavoritesStatus.initial,
    this.errorMessage,
  });

  bool isFavorite(String bookId) =>
      favorites.any((book) => book.id == bookId);

  FavoritesState copyWith({
    List<BookEntity>? favorites,
    FavoritesStatus? status,
    String? errorMessage,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [favorites, status, errorMessage];
}
