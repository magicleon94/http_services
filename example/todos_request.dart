import 'package:http_services/src/models/request_base.dart';

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
