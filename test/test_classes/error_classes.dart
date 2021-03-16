import 'package:http_services/http_services.dart';

class ErrorRequest extends RequestBase {
  final String _endpoint;

  ErrorRequest(this._endpoint);

  @override
  String get endpoint => _endpoint;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class ErrorResponse extends ResponseBase {
  final double? id;

  ErrorResponse({this.id});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      ErrorResponse(id: double.parse(json['id']));
}

class ErrorService extends HttpServiceBase {
  ErrorService(Dio dioInstance) : super(dioInstance);

  Future<ErrorResponse> getErrorByRoute(String route, {int? expectedCode}) {
    final request = ErrorRequest(route);
    return getQuery(
      request: request,
      mapper: (json, _) => ErrorResponse.fromJson(json),
      expectedStatusCode: expectedCode ?? 200,
    );
  }
}
