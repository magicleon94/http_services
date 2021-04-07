import 'package:http_services/http_services.dart';

import '../base_test_constants.dart';

class TestRequest extends RequestBase {
  final String _endpoint;

  TestRequest(this._endpoint);

  @override
  String get endpoint => _endpoint;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class JsonRequest extends RequestBase {
  final String _endpoint;

  JsonRequest(this._endpoint);

  @override
  String get endpoint => _endpoint;

  @override
  Map<String, dynamic> toJson() {
    return requestJson;
  }
}

class StringRequest extends RequestBase {
  final String _endpoint;

  StringRequest(this._endpoint);

  @override
  String get endpoint => _endpoint;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String toData() {
    return _endpoint;
  }
}

class TestResponse extends ResponseBase {
  final String? id;

  TestResponse({this.id});

  factory TestResponse.fromJson(Map<String, dynamic> json) =>
      TestResponse(id: json['id']);
}

class TestService extends HttpServiceBase {
  TestService(Dio dioInstance) : super(dioInstance);

  Future<TestResponse> getTest(String route) {
    final request = TestRequest(route);
    return getQuery(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
      orElse: (string, _) => TestResponse(id: string),
    );
  }

  Future<TestResponse> postJsonTest() {
    final request = JsonRequest(baseTestRoute);
    return postJson(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
    );
  }

  Future<TestResponse> postDataTest() {
    final request = StringRequest(baseTestRoute);
    return postData(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
    );
  }

  Future<TestResponse> patchJsonTest() {
    final request = JsonRequest(baseTestRoute);
    return patchJson(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
    );
  }

  Future<TestResponse> patchDataTest() {
    final request = StringRequest(baseTestRoute);
    return patchData(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
    );
  }

  Future<TestResponse> putJsonTest() {
    final request = JsonRequest(baseTestRoute);
    return putJson(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
    );
  }

  Future<TestResponse> putDataTest() {
    final request = StringRequest(baseTestRoute);
    return putData(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
    );
  }

  Future<TestResponse> deleteJsonTest() {
    final request = JsonRequest(baseTestRoute);
    return deleteJson(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
    );
  }

  Future<TestResponse> deleteDataTest() {
    final request = StringRequest(baseTestRoute);
    return deleteData(
      request: request,
      mapper: (json, _) => TestResponse.fromJson(json),
    );
  }
}
