import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? thumbnailUrl;
  final String? publishedDate;
  final String? publisher;
  final int? pageCount;

  const BookEntity({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.thumbnailUrl,
    this.publishedDate,
    this.publisher,
    this.pageCount,
  });

  String get authorsDisplay =>
      authors.isEmpty ? 'Unknown Author' : authors.join(', ');

  String get publishedYear {
    if (publishedDate == null || publishedDate!.isEmpty) return 'N/A';
    return publishedDate!.split('-').first;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        authors,
        description,
        thumbnailUrl,
        publishedDate,
        publisher,
        pageCount,
      ];
}
