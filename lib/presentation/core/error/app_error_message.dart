import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/app_error.dart';
import 'package:flutter_clean_bloc_skeleton/generated/locale_keys.g.dart';

/// Maps a typed [AppError] to a localized, user-facing message.
///
/// The switch is exhaustive over the sealed [AppError] hierarchy, so every
/// error category resolves to its own translation key; unknown causes are
/// already normalized to [UnexpectedError] by the data layer.
extension AppErrorMessage on AppError {
  /// The translation key for this error category (pure, no localization
  /// context required — useful for testing the mapping in isolation).
  String get localeKey => switch (this) {
    NetworkError() => LocaleKeys.error_network,
    ServerError() => LocaleKeys.error_server,
    AuthError() => LocaleKeys.error_auth,
    ParsingError() => LocaleKeys.error_parsing,
    UnexpectedError() => LocaleKeys.error_unexpected,
  };

  /// The localized, user-facing message for this error.
  String get localizedMessage => localeKey.tr();
}
