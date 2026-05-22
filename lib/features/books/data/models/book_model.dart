import '../../domain/entities/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    super.description,
    super.thumbnailUrl,
    super.publishedDate,
    super.publisher,
    super.pageCount,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = info['imageLinks'] as Map<String, dynamic>? ?? {};

    final rawThumbnail =
        imageLinks['thumbnail'] as String? ?? imageLinks['smallThumbnail'] as String?;
    final thumbnail = rawThumbnail?.replaceFirst('http://', 'https://');

    final rawAuthors = info['authors'];
    final authors = rawAuthors is List
        ? List<String>.from(rawAuthors.map((e) => e.toString()))
        : <String>[];

    return BookModel(
      id: json['id']?.toString() ?? '',
      title: info['title']?.toString() ?? 'Unknown Title',
      authors: authors,
      description: info['description']?.toString(),
      thumbnailUrl: thumbnail,
      publishedDate: info['publishedDate']?.toString(),
      publisher: info['publisher']?.toString(),
      pageCount: info['pageCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'description': description,
        'thumbnailUrl': thumbnailUrl,
        'publishedDate': publishedDate,
        'publisher': publisher,
        'pageCount': pageCount,
      };
}
