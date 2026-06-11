import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Centralized runtime configuration.
///
/// All app-level configuration values live here as the single source of truth
/// and are injected where needed (the API key for the auth interceptor, the
/// base URL for Dio). This is the only place these values appear in source.
@lazySingleton
class AppConfig {
  const AppConfig();

  String get apiKey => 'reqres-free-v1';

  /// API base URL, selected per build flavor.
  // TODO: Point production at its own URL once available.
  String get baseUrl => appFlavor == 'develop'
      ? 'https://restcountries.com/v3.1'
      : 'https://restcountries.com/v3.1';
}
