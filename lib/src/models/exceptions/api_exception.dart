import 'package:dio/dio.dart';
import 'package:http_services/src/models/exceptions/http_service_exception.dart';

import 'socket_exception.dart' if (dart.library.io) 'dart:io';

extension DioExtensions on DioError {
  bool get isNetworkError {
    return type == DioErrorType.connectTimeout ||
        type == DioErrorType.sendTimeout ||
        type == DioErrorType.receiveTimeout ||
        error is SocketException;
  }
}

///Thrown then something goes wrong with the request
class ApiException extends HttpServiceException {
  /// [networkError] signals if there was an outage in connection
  final bool networkError;

  /// [httpCode] is the received HTTP status code
  final int? httpCode;

  /// [httpMessage] is the received HTTP status message
  final String? httpMessage;

  /// [body] is the body of the HTTP error response.
  /// It may be `null` if the request can't reach to
  /// the http server, for example, occurring a dns error, network is not available.
  final dynamic body;

  /// The original unparsed exception
  final Exception? error;

  ApiException({
    required this.networkError,
    this.httpCode,
    this.httpMessage,
    this.body,
    this.error,
  });

  factory ApiException.fromDioError(DioError dioError) {
    return ApiException(
      httpCode: dioError.response?.statusCode ?? -1,
      httpMessage: dioError.response?.statusMessage ?? '-',
      networkError: dioError.isNetworkError,
      body: dioError.response?.data,
      error: dioError,
    );
  }

  String toString() => httpMessage ?? super.toString();
}
