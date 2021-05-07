import 'package:http_services/http_services.dart';

class BytesResponse extends ResponseBase {
  final List<int> bytes;

  BytesResponse(this.bytes);
}
