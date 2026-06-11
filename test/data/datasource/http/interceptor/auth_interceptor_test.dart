import 'package:dio/dio.dart';
import 'package:flutter_clean_bloc_skeleton/data/datasource/http/interceptor/auth_interceptor.dart';
import 'package:flutter_clean_bloc_skeleton/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAppConfig extends AppConfig {
  const _FakeAppConfig();
  @override
  String get apiKey => 'test-key';
}

void main() {
  test('onRequest sets the x-api-key header from AppConfig', () {
    final interceptor = AuthInterceptor(const _FakeAppConfig());
    final options = RequestOptions(path: '/test');

    interceptor.onRequest(options, RequestInterceptorHandler());

    expect(options.headers['x-api-key'], equals('test-key'));
  });
}
