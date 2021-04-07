import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_services/http_services.dart';
import 'package:test/test.dart';

import 'errors_test_constants.dart';
import 'test_classes/error_classes.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter();
  final testService = ErrorService(dio);

  setUp(
    () {
      dio.httpClientAdapter = dioAdapter;
      dioAdapter.onGet(
        dioErrorRoute,
        (handler) => handler.throws(
          500,
          DioError(
            error: "Test",
            requestOptions: RequestOptions(path: dioErrorRoute),
          ),
        ),
      );
      dioAdapter.onGet(
        statusCodeErrorRoute,
        (handler) => handler.reply(
          200,
          {},
        ),
      );
      dioAdapter.onGet(
        wrongResponseRoute,
        (handler) => handler.reply(200, "Not_A_Json"),
      );
      dioAdapter.onGet(
        wrongJsonDataRoute,
        (handler) => handler.reply(200, {"id": "Not_A_Double"}),
      );
    },
  );

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
