# http_services
A package to support the creation of Http services in a Dart application.

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

# Usage example
```
import 'package:dio/dio.dart';
import 'package:http_services/http_services.dart';

import 'todos_service.dart';

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
