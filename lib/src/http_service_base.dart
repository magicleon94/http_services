import 'package:dio/dio.dart';
import 'package:disposable_object/disposable_object.dart';
import 'package:http_services/src/models/exceptions/api_exception.dart';
import 'package:http_services/src/models/exceptions/http_service_exception.dart';
import 'package:http_services/src/models/exceptions/response_mapping_exception.dart';
import 'package:http_services/src/models/exceptions/unexpected_status_code_exception.dart';
import 'package:http_services/src/models/request_base.dart';
import 'package:http_services/src/models/response_base.dart';
import 'package:meta/meta.dart';

abstract class HttpServiceBase extends DisposableObject {
  final Dio dioInstance;
  HttpServiceBase(this.dioInstance);
  @protected
  List<CancelToken> cancelTokens = [];

  ///Get a token to attach to a request in order to dispose it later
  @protected
  CancelToken getNextToken() {
    var token = CancelToken();
    cancelTokens..add(token);
    return cancelTokens.last;
  }

  ///Clear all pending requests
  @protected
  void clearTokens() {
    cancelTokens.forEach((token) {
      token.cancel();
    });
    cancelTokens.clear();
  }

  @override
  @mustCallSuper
  void disposeInstance() {
    clearTokens();
  }

  void _assertStatusCode(int expected, int actual) {
    if (expected != actual) {
      throw UnexpectedStatusCodeException(expected, actual);
    }
  }

  T _mapResponse<T extends ResponseBase>(
      Response response,
      T Function(Map<String, dynamic>, Response response) mapper,
      T Function(dynamic, Response response)? orElse) {
    if (response.data is Map<String, dynamic>) {
      return mapper(response.data, response);
    } else {
      if (orElse != null) {
        return orElse(response.data, response);
      }
      throw Exception(
        'orElse mapping function must not be null for non json response.',
      );
    }
  }

  Future<T> _perform<T extends ResponseBase>(
    Future<Response> Function() performer,
    T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    int expectedStatusCode,
  ) async {
    try {
      final response = await performer();
      _assertStatusCode(expectedStatusCode, response.statusCode ?? -1);
      return _mapResponse(response, mapper, orElse);
    } on DioError catch (error) {
      throw ApiException.fromDioError(error);
    } on HttpServiceException catch (_) {
      rethrow;
    } catch (e) {
      throw ResponseMappingException(e.toString());
    }
  }

  /// Perform a query using the "GET" method.
  /// The query parameters are extracted from [request]
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> getQuery<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.get(
          request.endpoint,
          queryParameters: request.toJson(),
          options: options,
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }

  /// Perform a query using the "POST" method.
  /// The body of the request is extracted from [request]'s [toData] method
  /// Optionally pass [queryParameters] for query parameters attached to the request
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> postData<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    Map<String, dynamic> queryParameters = const {},
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.post(
          request.endpoint,
          data: request.toData(),
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }

  /// Perform a query using the "POST" method and using the JSON content type
  /// The body of the request is extracted from [request]
  /// Optionally pass [queryParameters] for query parameters attached to the request
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> postJson<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    Map<String, dynamic> queryParameters = const {},
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.post(
          request.endpoint,
          data: request.toJson(),
          queryParameters: queryParameters,
          options: options?.copyWith(
                contentType: 'application/json',
              ) ??
              Options(
                contentType: 'application/json',
              ),
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }

  /// Perform a query using the "DELETE" method.
  /// The body of the request is extracted from [request]'s [toData] method
  /// Optionally pass [queryParameters] for query parameters attached to the request
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> deleteData<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    Map<String, dynamic> queryParameters = const {},
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.delete(
          request.endpoint,
          data: request.toData(),
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }

  /// Perform a query using the "DELETE" method and using the JSON content type
  /// The body of the request is extracted from [request]
  /// Optionally pass [queryParameters] for query parameters attached to the request
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> deleteJson<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    Map<String, dynamic> queryParameters = const {},
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.delete(
          request.endpoint,
          data: request.toJson(),
          queryParameters: queryParameters,
          options: options?.copyWith(contentType: 'application/json') ??
              Options(contentType: 'application/json'),
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }

  /// Perform a query using the "PUT" method.
  /// The body of the request is extracted from [request]'s [toData] method
  /// Optionally pass [queryParameters] for query parameters attached to the request
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> putData<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    Map<String, dynamic> queryParameters = const {},
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.put(
          request.endpoint,
          data: request.toData(),
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }

  /// Perform a query using the "PUT" method and using the JSON content type
  /// The body of the request is extracted from [request]
  /// Optionally pass [queryParameters] for query parameters attached to the request
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> putJson<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    Map<String, dynamic> queryParameters = const {},
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.put(
          request.endpoint,
          data: request.toJson(),
          queryParameters: queryParameters,
          options: options?.copyWith(contentType: 'application/json') ??
              Options(contentType: 'application/json'),
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }

  /// Perform a query using the "PATCH" method.
  /// The body of the request is extracted from [request]'s [toData] method
  /// Optionally pass [queryParameters] for query parameters attached to the request
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> patchData<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    Map<String, dynamic> queryParameters = const {},
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.patch(
          request.endpoint,
          data: request.toData(),
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }

  /// Perform a query using the "PATCH" method and using the JSON content type
  /// The body of the request is extracted from [request]
  /// Optionally pass [queryParameters] for query parameters attached to the request
  /// Use [mapper] to map the json response
  /// Optionally you can use the [orElse] to map other kind of response
  /// Optionally you can specify [options] to pass to Dio
  /// [cancelOnDispose] lets you cancel the request if this service is disposed
  /// [expectedStatusCode] to check the result of the request
  @protected
  Future<T> patchJson<T extends ResponseBase>({
    required RequestBase request,
    required T Function(Map<String, dynamic>, Response response) mapper,
    T Function(dynamic, Response response)? orElse,
    Options? options,
    bool cancelOnDispose = true,
    Map<String, dynamic> queryParameters = const {},
    int expectedStatusCode = 200,
  }) async {
    final performer = () => dioInstance.patch(
          request.endpoint,
          data: request.toJson(),
          queryParameters: queryParameters,
          options: options?.copyWith(contentType: 'application/json') ??
              Options(contentType: 'application/json'),
          cancelToken: cancelOnDispose ? getNextToken() : null,
        );
    return _perform(performer, mapper, orElse, expectedStatusCode);
  }
}
