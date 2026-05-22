import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> fetchBooks({
    required String query,
    required int startIndex,
    int maxResults,
  });
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final DioClient _client;
  const BookRemoteDataSourceImpl(this._client);

  @override
  Future<List<BookModel>> fetchBooks({
    required String query,
    required int startIndex,
    int maxResults = ApiConstants.defaultMaxResults,
  }) async {
    final response = await _client.get(
      ApiConstants.booksEndpoint,
      queryParameters: {
        'q': query,
        'startIndex': startIndex,
        'maxResults': maxResults,
        'printType': 'books',
      },
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final items = data['items'];
      if (items == null) return [];
      return (items as List)
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw ServerException(
      'Failed to fetch books',
      response.statusCode,
      response.data,
    );
  }
}
