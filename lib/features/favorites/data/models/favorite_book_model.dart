import 'package:hive/hive.dart';
import '../../../books/domain/entities/book_entity.dart';

part 'favorite_book_adapter.dart';

class FavoriteBookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? thumbnailUrl;
  final String? publishedDate;
  final String? publisher;
  final int? pageCount;

  const FavoriteBookModel({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.thumbnailUrl,
    this.publishedDate,
    this.publisher,
    this.pageCount,
  });

  factory FavoriteBookModel.fromEntity(BookEntity entity) => FavoriteBookModel(
        id: entity.id,
        title: entity.title,
        authors: entity.authors,
        description: entity.description,
        thumbnailUrl: entity.thumbnailUrl,
        publishedDate: entity.publishedDate,
        publisher: entity.publisher,
        pageCount: entity.pageCount,
      );

  BookEntity toEntity() => BookEntity(
        id: id,
        title: title,
        authors: authors,
        description: description,
        thumbnailUrl: thumbnailUrl,
        publishedDate: publishedDate,
        publisher: publisher,
        pageCount: pageCount,
      );
}
