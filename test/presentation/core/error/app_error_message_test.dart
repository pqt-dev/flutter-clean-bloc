import 'package:flutter_clean_bloc_skeleton/domain/core/app_error.dart';
import 'package:flutter_clean_bloc_skeleton/generated/locale_keys.g.dart';
import 'package:flutter_clean_bloc_skeleton/presentation/core/error/app_error_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppErrorMessage.localeKey', () {
    test('NetworkError → error.network', () {
      expect(const NetworkError().localeKey, equals(LocaleKeys.error_network));
    });

    test('ServerError → error.server', () {
      expect(const ServerError().localeKey, equals(LocaleKeys.error_server));
    });

    test('AuthError → error.auth', () {
      expect(const AuthError().localeKey, equals(LocaleKeys.error_auth));
    });

    test('ParsingError → error.parsing', () {
      expect(const ParsingError().localeKey, equals(LocaleKeys.error_parsing));
    });

    test('UnexpectedError → error.unexpected', () {
      expect(
        const UnexpectedError().localeKey,
        equals(LocaleKeys.error_unexpected),
      );
    });

    test('each error category maps to a distinct key', () {
      final keys = <String>{
        const NetworkError().localeKey,
        const ServerError().localeKey,
        const AuthError().localeKey,
        const ParsingError().localeKey,
        const UnexpectedError().localeKey,
      };
      expect(keys, hasLength(5));
    });
  });
}
