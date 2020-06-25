import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_services/src/models/exceptions/http_service_exception.dart';

extension DioExtensions on DioError {
  bool get isNetworkError {
    return type == DioErrorType.CONNECT_TIMEOUT ||
        type == DioErrorType.SEND_TIMEOUT ||
        type == DioErrorType.RECEIVE_TIMEOUT ||
        error is SocketException;
  }
}

///Thrown then something goes wrong with the request
/// [networkError] signals if there was an outage in connection
/// [httpCode] is the received HTTP status code
/// [httpMessage] is the received HTTP status message
class ApiException extends HttpServiceException {
  final bool networkError;
  final int httpCode;
  final String httpMessage;

  ApiException({
    this.networkError,
    this.httpCode,
    this.httpMessage,
  });

  factory ApiException.fromDioError(DioError dioError) {
    return ApiException(
      httpCode: dioError.response?.statusCode ?? -1,
      httpMessage: dioError.response?.statusMessage ?? '-',
      networkError: dioError.isNetworkError,
    );
  }

  String toString() => httpMessage ?? super.toString();
}
