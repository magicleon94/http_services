import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_services/http_services.dart';
import 'package:test/test.dart';

import 'base_test_constants.dart';
import 'test_classes/base_classes.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter();
  final testService = TestService(dio);

  setUp(() {
    dio.httpClientAdapter = dioAdapter;
    dioAdapter.onGet(
      baseTestRoute,
      (handler) => handler.reply(200, successJson),
    );
    dioAdapter.onGet(
      orElseTestRoute,
      (handler) => handler.reply(200, successString),
    );
    dioAdapter.onPost(
        baseTestRoute, (handler) => handler.reply(200, successJson),
        data: requestJson,
        headers: {
          Headers.contentTypeHeader: 'application/json',
          Headers.contentLengthHeader: 15
        });
    dioAdapter.onPost(
      baseTestRoute,
      (handler) => handler.reply(200, successJson),
      data: baseTestRoute,
    );
    dioAdapter.onPatch(
        baseTestRoute, (handler) => handler.reply(200, successJson),
        data: requestJson,
        headers: {
          Headers.contentTypeHeader: 'application/json',
          Headers.contentLengthHeader: 15
        });
    dioAdapter.onPatch(
      baseTestRoute,
      (handler) => handler.reply(200, successJson),
      data: baseTestRoute,
    );
    dioAdapter.onPut(
        baseTestRoute, (handler) => handler.reply(200, successJson),
        data: requestJson,
        headers: {
          Headers.contentTypeHeader: 'application/json',
          Headers.contentLengthHeader: 15
        });
    dioAdapter.onPut(
      baseTestRoute,
      (handler) => handler.reply(200, successJson),
      data: baseTestRoute,
    );
    dioAdapter.onDelete(
        baseTestRoute, (handler) => handler.reply(200, successJson),
        data: requestJson,
        headers: {
          Headers.contentTypeHeader: 'application/json',
          Headers.contentLengthHeader: 15
        });
    dioAdapter.onDelete(
      baseTestRoute,
      (handler) => handler.reply(200, successJson),
      data: baseTestRoute,
    );
  });

  group("HttpServiceBase", () {
    test(".getQuery should work with default mapper", () async {
      TestResponse res = await testService.getTest(baseTestRoute);
      expect(res.id, successString);
    });

    test(".getQuery should work with orElse mapper", () async {
      TestResponse res = await testService.getTest(orElseTestRoute);
      expect(res.id, successString);
    });

    test(".postJson should correctly pass request param", () async {
      TestResponse res = await testService.postJsonTest();
      expect(res.id, successString);
    });

    test(".postData should correctly pass request param", () async {
      TestResponse res = await testService.postDataTest();
      expect(res.id, successString);
    });

    test(".patchJson should correctly pass request param", () async {
      TestResponse res = await testService.patchJsonTest();
      expect(res.id, successString);
    });

    test(".patchData should correctly pass request param", () async {
      TestResponse res = await testService.patchDataTest();
      expect(res.id, successString);
    });

    test(".putJson should correctly pass request param", () async {
      TestResponse res = await testService.putJsonTest();
      expect(res.id, successString);
    });

    test(".putData should correctly pass request param", () async {
      TestResponse res = await testService.putDataTest();
      expect(res.id, successString);
    });

    test(".deleteJson should correctly pass request param", () async {
      TestResponse res = await testService.deleteJsonTest();
      expect(res.id, successString);
    });

    test(".deleteData should correctly pass request param", () async {
      TestResponse res = await testService.deleteDataTest();
      expect(res.id, successString);
    });
  });
}
