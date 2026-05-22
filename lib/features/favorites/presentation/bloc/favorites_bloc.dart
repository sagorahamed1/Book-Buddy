import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;

  FavoritesBloc({
    required this.getFavoritesUseCase,
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
  }) : super(const FavoritesState()) {
    on<LoadFavoritesEvent>(_onLoad);
    on<ToggleFavoriteEvent>(_onToggle);
  }

  Future<void> _onLoad(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    final result = await getFavoritesUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: FavoritesStatus.error,
        errorMessage: failure.message,
      )),
      (favorites) => emit(state.copyWith(
        favorites: favorites,
        status: FavoritesStatus.loaded,
      )),
    );
  }

  Future<void> _onToggle(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final alreadyFav = state.isFavorite(event.book.id);

    if (alreadyFav) {
      final result = await removeFavoriteUseCase(event.book.id);
      result.fold(
        (failure) => emit(state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: failure.message,
        )),
        (_) {
          final updated =
              state.favorites.where((b) => b.id != event.book.id).toList();
          emit(state.copyWith(
            favorites: updated,
            status: FavoritesStatus.loaded,
          ));
        },
      );
    } else {
      final result = await addFavoriteUseCase(event.book);
      result.fold(
        (failure) => emit(state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: failure.message,
        )),
        (_) => emit(state.copyWith(
          favorites: [...state.favorites, event.book],
          status: FavoritesStatus.loaded,
        )),
      );
    }
  }
}
