import 'package:dio/dio.dart';
import 'package:flutter_clean_bloc_skeleton/core/config/app_config.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  final AppConfig _config;

  AuthInterceptor(this._config);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-api-key'] = _config.apiKey;
    super.onRequest(options, handler);
  }
}
