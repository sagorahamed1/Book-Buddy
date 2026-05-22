import 'package:go_router/go_router.dart';
import '../../features/books/domain/entities/book_entity.dart';
import '../../features/books/presentation/pages/book_detail_page.dart';
import '../../features/books/presentation/pages/book_list_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';

class AppRouter {


  /// Route name
  static const String book   = '/book';
  static const String bookDetail = 'bookDetail';
  static const String favorites  = '/favorites';

  static final GoRouter router = GoRouter(
    initialLocation: book,
    routes: [

      GoRoute(
        path: book,
        name: book,
        builder: (context, state) => const BookListPage(),
      ),

      GoRoute(
        path: '/book/:id',
        name: bookDetail,
        builder: (context, state) {
          final book = state.extra as BookEntity;
          return BookDetailPage(book: book);
        },
      ),

      GoRoute(
        path: favorites,
        name: favorites,
        builder: (context, state) => const FavoritesPage(),
      ),
    ],
  );
}
