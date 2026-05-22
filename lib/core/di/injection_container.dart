import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/books/data/datasources/book_remote_datasource.dart';
import '../../features/books/data/repositories/book_repository_impl.dart';
import '../../features/books/domain/repositories/book_repository.dart';
import '../../features/books/domain/usecases/get_books_usecase.dart';
import '../../features/books/presentation/bloc/book_list_bloc.dart';
import '../../features/favorites/data/datasources/favorites_local_datasource.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/add_favorite_usecase.dart';
import '../../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/remove_favorite_usecase.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../network/dio_client.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Hive.initFlutter();

  final favBox = await FavoritesLocalDataSourceImpl.openBox();

  // Core
  serviceLocator.registerLazySingleton(() => DioClient());

  // Data sources
  serviceLocator.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(favBox),
  );

  // Repositories
  serviceLocator.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: serviceLocator()),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => GetBooksUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetFavoritesUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddFavoriteUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => RemoveFavoriteUseCase(serviceLocator()));

  // BLoCs (factory so each widget tree gets a fresh instance)
  serviceLocator.registerFactory(() => BookListBloc(getBooksUseCase: serviceLocator()));
  serviceLocator.registerFactory(
    () => FavoritesBloc(
      getFavoritesUseCase: serviceLocator(),
      addFavoriteUseCase: serviceLocator(),
      removeFavoriteUseCase: serviceLocator(),
    ),
  );
}
