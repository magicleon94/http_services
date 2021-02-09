import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

import 'package:dio/dio.dart';
import 'package:http_services/http_services.dart';

import 'test_classes/error_classes.dart';
import 'errors_test_constants.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter();
  final testService = ErrorService(dio);

  setUp(() {
    dio.httpClientAdapter = dioAdapter;
    dioAdapter.onGet(dioErrorRoute).throws(500, DioError(error: "Test"));
    dioAdapter.onGet(statusCodeErrorRoute).reply(200, {});
    dioAdapter.onGet(wrongResponseRoute).reply(200, "Not_A_Json");
    dioAdapter.onGet(wrongJsonDataRoute).reply(200, {"id": "Not_A_Double"});
  });

  group("HttpServiceBase", () {
    test("should throw ApiException when DioError occures", () async {
      expect(
        () async => await testService.getErrorByRoute(dioErrorRoute),
        throwsA(TypeMatcher<ApiException>()),
      );
    });

    test(
      "should throw UnexpectedStatusCodeException with different expected status code",
      () async {
        expect(
          () async => await testService.getErrorByRoute(
            statusCodeErrorRoute,
            expectedCode: 201,
          ),
          throwsA(TypeMatcher<UnexpectedStatusCodeException>()),
        );
      },
    );

    test(
      "should throw ResponseMappingException when API returns an unexpected response type (not handled by the orElse function)",
      () async {
        expect(
          () async => await testService.getErrorByRoute(wrongResponseRoute),
          throwsA(TypeMatcher<ResponseMappingException>()),
        );
        expect(
          () async => await testService.getErrorByRoute(wrongJsonDataRoute),
          throwsA(TypeMatcher<ResponseMappingException>()),
        );
      },
    );
  });
}
