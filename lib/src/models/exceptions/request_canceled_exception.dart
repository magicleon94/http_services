import 'package:http_services/http_services.dart';

///Thrown when a request is canceled
class RequestCanceledException extends HttpServiceException {
  final DioError error;
  RequestCanceledException(this.error);
}
