import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

import 'package:dio/dio.dart';
import 'package:http_services/http_services.dart';

import 'test_classes/base_classes.dart';
import 'base_test_constants.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter();
  final testService = TestService(dio);

  setUp(() {
    dio.httpClientAdapter = dioAdapter;
    dioAdapter.onGet(baseTestRoute).reply(200, successJson);
    dioAdapter.onGet(orElseTestRoute).reply(200, successString);
    dioAdapter.onPost(baseTestRoute, data: requestJson).reply(200, successJson);
    dioAdapter
        .onPost(baseTestRoute, data: baseTestRoute)
        .reply(200, successJson);
    dioAdapter
        .onPatch(baseTestRoute, data: requestJson)
        .reply(200, successJson);
    dioAdapter
        .onPatch(baseTestRoute, data: baseTestRoute)
        .reply(200, successJson);
    dioAdapter.onPut(baseTestRoute, data: requestJson).reply(200, successJson);
    dioAdapter
        .onPut(baseTestRoute, data: baseTestRoute)
        .reply(200, successJson);
    dioAdapter
        .onDelete(baseTestRoute, data: requestJson)
        .reply(200, successJson);
    dioAdapter
        .onDelete(baseTestRoute, data: baseTestRoute)
        .reply(200, successJson);
  });

  group("HttpServices", () {
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
