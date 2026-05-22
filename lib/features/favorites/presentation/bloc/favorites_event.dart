import 'package:equatable/equatable.dart';
import '../../../books/domain/entities/book_entity.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final BookEntity book;
  const ToggleFavoriteEvent(this.book);

  @override
  List<Object> get props => [book];
}
