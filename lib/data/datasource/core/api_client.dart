import 'package:dio/dio.dart';
import 'package:flutter_clean_bloc/data/failures/exception_mapper.dart';
import 'package:flutter_clean_bloc/domain/core/app_error.dart';
import 'package:flutter_clean_bloc/domain/core/result.dart';
import 'package:injectable/injectable.dart';

enum ApiMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE')
  ;

  final String value;

  const ApiMethod(this.value);
}

typedef ResponseDecoder<T> = T Function(dynamic data);

@lazySingleton
class ApiClient {
  final Dio dio;
  final ExceptionMapper exceptionMapper;

  ApiClient(this.dio, this.exceptionMapper);

  Future<Result<T>> request<T>({
    required String endpoint,
    required ApiMethod method,
    required ResponseDecoder<T> decoder,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.request(
        endpoint,
        queryParameters: queryParameters,
        options: options?.copyWith(
          method: method.value,
        ),
        data: data,
        cancelToken: cancelToken,
      );
      try {
        return Success(decoder(response.data));
      } catch (e, st) {
        // Any failure turning the response body into T is a data/shape problem.
        return Failure(ParsingError(cause: e, stackTrace: st));
      }
    } on Exception catch (e, st) {
      // Expected runtime failures (network, server, auth...) are mapped to a
      // typed AppError. Errors (programming bugs) are left to propagate.
      return Failure(exceptionMapper.map(e, st));
    }
  }
}
