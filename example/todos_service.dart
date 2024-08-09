import 'package:http_services/http_services.dart';

import 'todos_request.dart';
import 'todos_response.dart';

class TodosService extends HttpServiceBase {
  TodosService(Dio dioInstance) : super(dioInstance);

  Future<TodosResponse> getTodo(int page) {
    final request = TodosRequest(page);

    return getQuery(
      request: request,
      mapper: (json, _) => TodosResponse.fromJson(json),
    );
  }

  Future<PostResponse> postBoh() {
    final request = PostRequest();

    return postJson(
      request: request,
      mapper: (json, _) => PostResponse(),
      expectedStatusCode: 201,
    );
  }
}
