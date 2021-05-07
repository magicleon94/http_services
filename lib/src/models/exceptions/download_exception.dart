import 'package:http_services/src/models/exceptions/http_service_exception.dart';

///Thrown when something bad occurs with the file download
class DownloadException extends HttpServiceException {
  final String message;
  final StackTrace stackTrace;

  DownloadException(this.message, this.stackTrace);
}
