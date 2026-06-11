import 'package:dio/dio.dart';
import 'package:flutter_clean_bloc/data/datasource/http/api_client.dart';
import 'package:flutter_clean_bloc/data/failures/exception_mapper.dart';
import 'package:flutter_clean_bloc/domain/core/app_error.dart';
import 'package:flutter_clean_bloc/domain/core/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_client_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio dio;
  late ApiClient client;

  setUp(() {
    dio = MockDio();
    client = ApiClient(dio, const ExceptionMapper());
  });

  Response<dynamic> response(dynamic data) =>
      Response(requestOptions: RequestOptions(path: '/x'), data: data);

  void stubRequestAnswer(Response<dynamic> value) {
    when(
      dio.request<dynamic>(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
        cancelToken: anyNamed('cancelToken'),
      ),
    ).thenAnswer((_) async => value);
  }

  void stubRequestThrow(Object error) {
    when(
      dio.request<dynamic>(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
        cancelToken: anyNamed('cancelToken'),
      ),
    ).thenThrow(error);
  }

  Future<Result<String>> call() => client.request<String>(
        endpoint: '/x',
        method: ApiMethod.get,
        decoder: (data) => (data as Map)['k'] as String,
      );

  test('returns Success when request and decode succeed', () async {
    stubRequestAnswer(response({'k': 'v'}));

    final result = await call();

    expect(result, isA<Success<String>>());
    expect((result as Success).value, equals('v'));
  });

  test('maps a DioException to a typed AppError Failure', () async {
    stubRequestThrow(
      DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/x'),
      ),
    );

    final result = await call();

    expect(result, isA<Failure>());
    expect((result as Failure).error, isA<NetworkError>());
  });

  test('maps a decode failure to ParsingError instead of throwing', () async {
    stubRequestAnswer(response('not-a-map'));

    final result = await call();

    expect(result, isA<Failure>());
    expect((result as Failure).error, isA<ParsingError>());
  });

  test('lets a programming Error from the request propagate (not swallowed)',
      () async {
    stubRequestThrow(StateError('bug'));

    expect(call(), throwsA(isA<StateError>()));
  });
}
