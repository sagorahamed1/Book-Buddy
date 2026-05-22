

/// **** development : Developer is working locally.
/// **** staging : QA team is testing before release.
/// **** production : Real users are using the app.
enum Flavor { development, staging, production }


/// A singleton class that holds app-wide configuration.
/// Must be initialized once before runApp by calling AppConfig.init.

class AppConfig {
  final String baseUrl;
  final String appName;
  final Flavor flavor;
  final String apiKey;

  static AppConfig? _instance;

  AppConfig._({
    required this.baseUrl,
    required this.appName,
    required this.flavor,
    required this.apiKey,
  });

  static AppConfig get instance {

    /// ********* Throws a error if AppConfig not init from main function before runApp

    if (_instance == null) {
      throw StateError(
        'AppConfig not initialized. Call AppConfig.init() before runApp().',
      );
    }
    return _instance!;
  }

  static void init({
    required String baseUrl,
    required String appName,
    required Flavor flavor,
    String apiKey = '',
  }) {
    if (_instance != null) return;
    _instance = AppConfig._(
      baseUrl: baseUrl,
      appName: appName,
      flavor: flavor,
      apiKey: apiKey,
    );
  }

  bool get isDev    => flavor == Flavor.development;
  bool get isProd   => flavor == Flavor.production;
  bool get hasApiKey => apiKey.isNotEmpty;
}