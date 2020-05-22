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
