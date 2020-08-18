import 'package:dio/dio.dart';
import 'package:http_services/src/models/exceptions/http_service_exception.dart';

import 'socket_exception.dart' if (dart.library.io) 'dart:io';

extension DioExtensions on DioError {
  bool get isNetworkError {
    return type == DioErrorType.CONNECT_TIMEOUT ||
        type == DioErrorType.SEND_TIMEOUT ||
        type == DioErrorType.RECEIVE_TIMEOUT ||
        error is SocketException;
  }
}

///Thrown then something goes wrong with the request
class ApiException extends HttpServiceException {
  /// [networkError] signals if there was an outage in connection
  final bool networkError;

  /// [httpCode] is the received HTTP status code
  final int httpCode;

  /// [httpMessage] is the received HTTP status message
  final String httpMessage;

  /// [body] is the body of the HTTP error response.
  /// It may be `null` if the request can't reach to
  /// the http server, for example, occurring a dns error, network is not available.
  final dynamic body;

  ApiException({
    this.networkError,
    this.httpCode,
    this.httpMessage,
    this.body,
  });

  factory ApiException.fromDioError(DioError dioError) {
    return ApiException(
      httpCode: dioError.response?.statusCode ?? -1,
      httpMessage: dioError.response?.statusMessage ?? '-',
      networkError: dioError.isNetworkError,
      body: dioError.response?.data,
    );
  }

  String toString() => httpMessage ?? super.toString();
}
