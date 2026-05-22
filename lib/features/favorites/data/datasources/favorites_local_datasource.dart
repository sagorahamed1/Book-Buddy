import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../models/favorite_book_model.dart';

abstract class FavoritesLocalDataSource {
  List<BookEntity> getFavorites();
  Future<void> addFavorite(BookEntity book);
  Future<void> removeFavorite(String bookId);
  bool isFavorite(String bookId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Box<FavoriteBookModel> _box;
  const FavoritesLocalDataSourceImpl(this._box);

  static Future<Box<FavoriteBookModel>> openBox() async {
    if (!Hive.isAdapterRegistered(AppConstants.favoriteTypeId)) {
      Hive.registerAdapter(FavoriteBookAdapter());
    }
    return Hive.openBox<FavoriteBookModel>(AppConstants.favoritesBoxName);
  }

  @override
  List<BookEntity> getFavorites() {
    try {
      return _box.values.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw CacheException('Failed to read favorites: $e');
    }
  }

  @override
  Future<void> addFavorite(BookEntity book) async {
    try {
      await _box.put(book.id, FavoriteBookModel.fromEntity(book));
    } catch (e) {
      throw CacheException('Failed to save favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(String bookId) async {
    try {
      await _box.delete(bookId);
    } catch (e) {
      throw CacheException('Failed to remove favorite: $e');
    }
  }

  @override
  bool isFavorite(String bookId) => _box.containsKey(bookId);
}
