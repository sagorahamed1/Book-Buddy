import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_config.dart';
import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/books/presentation/bloc/book_list_bloc.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/favorites/presentation/bloc/favorites_event.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<BookListBloc>(),
        ),
        BlocProvider(
          create: (_) =>
              serviceLocator<FavoritesBloc>()..add(const LoadFavoritesEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.instance.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
