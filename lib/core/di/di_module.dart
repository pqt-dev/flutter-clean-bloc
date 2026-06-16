import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasource/http/interceptor/auth_interceptor.dart';
import '../config/app_config.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    PrettyDioLogger logger,
    AppConfig config,
  ) {
    final dio = Dio(BaseOptions(baseUrl: config.baseUrl));
    dio.interceptors.add(authInterceptor);
    if (kDebugMode) {
      dio.interceptors.add(logger);
    }
    return dio;
  }

  @lazySingleton
  PrettyDioLogger get prettyDioLogger => PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  );
}

@module
abstract class StorageModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

@module
abstract class LoggingModule {
  @lazySingleton
  Logger get logger => Logger();
}
