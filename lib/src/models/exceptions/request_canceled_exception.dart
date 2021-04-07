import 'package:http_services/http_services.dart';
import 'package:http_services/src/models/exceptions/http_service_exception.dart';

///Thrown when a request is canceled
class RequestCanceledException extends HttpServiceException {
  final DioError error;
  RequestCanceledException(this.error);
}
