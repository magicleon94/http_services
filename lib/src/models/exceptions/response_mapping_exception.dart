import 'package:http_services/src/models/exceptions/http_service_exception.dart';

///Thrown when something bad occurs while mapping the response
class ResponseMappingException extends HttpServiceException {
  final String message;
  final StackTrace stackTrace;

  ResponseMappingException(this.message, this.stackTrace);
}
