# http_services
A package to support the creation of Http services in a Dart application.

# Features
* convenient methods to perform HTTP requests
* disposing a service will cleanup any pending requests, in order to avoid unwanted resources waste!
* convenient models to have a standard for request and response objects 

# RequestBase
Every request should extend `RequestBase` and implement its overrides:
* `endpoint`: Specify the path of the request
* `toJson`: This method is used for the request's serialization
* `toData`: This is an optional override in case you need to post a **non** JSON body. It returns an object of type `T`.

**By default `toData` returns `null`**

# ResponseBase
Every response should extend `ResponseBase`

# Exceptions
All the exceptions of this package `extend` `HttpServiceException`

### ApiException:
This is thrown when something is wrong with the request (e.g. missing internet, resource not found, etc).
* `networkError` signals if there was an outage in connection
* `httpCode` is the received HTTP status code
* `httpMessage` is the received HTTP status message

### UnexpectedStatusCodeException:
This is thrown when expected HTTP code doesn't match the received one.
* `expected` is the expected status code
* `actual` is the received status code

### ResponseMappingException:
This is thrown when an error occurs while mapping the response.

# HttpServiceBase
Every service should `extend` this.

To make a request within you service, you can use one of the following:
* `getQuery`: perform a `GET` request
* `postData`: perform a `POST` request
* `postJson`: perform a `POST` request **with a JSON body**

# Example
```dart
import 'package:dio/dio.dart';
import 'package:http_services/http_services.dart';

import 'todos_service.dart';


class TodosRequest extends RequestBase {
  final int page;

  TodosRequest(this.page) : assert(page != null && page > 0);
  @override
  String get endpoint => '/todos/$page';

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}


class TodosResponse extends ResponseBase {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodosResponse({
    this.userId,
    this.id,
    this.title,
    this.completed,
  });

  factory TodosResponse.fromJson(Map<String, dynamic> json) => TodosResponse(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        completed: json['completed'],
      );
}


class TodosService extends HttpServiceBase {
  TodosService(Dio dioInstance) : super(dioInstance);

  Future<TodosResponse> getTodo(int page) {
    final request = TodosRequest(page);

    return getQuery(
      request: request,
      mapper: (json) => TodosResponse.fromJson(json),
    );
  }
}

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
    ),
  );

  final service = TodosService(dio);

  try {
    print("Requesting data...");
    final response1 = await service.getTodo(1);
    print(
      "user id: ${response1.userId}\n"
      "id: ${response1.id}\n"
      "title: ${response1.title}\n"
      "completed: ${response1.completed}",
    );
  } on HttpServiceException catch (e) {
    print('Service exception: ${e.runtimeType}');
  }
}
```
