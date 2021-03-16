import 'package:http_services/src/models/response_base.dart';

class TodosResponse extends ResponseBase {
  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;

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

class PostResponse extends ResponseBase {}
