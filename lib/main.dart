import 'package:bookbuddy/core/config/app_config.dart';
import 'package:bookbuddy/core/di/injection_container.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/secrets.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(
    baseUrl: 'https://www.googleapis.com/books/v1/',
    appName: 'BookBuddy',
    flavor: Flavor.production,
    apiKey:  String.fromEnvironment(
      'BOOKS_API_KEY',
      defaultValue: Secrets.booksApiKey,
    ),
  );

  await initDependencies();
  runApp(const App());

}
