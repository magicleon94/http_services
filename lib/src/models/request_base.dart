abstract class RequestBase<T> {
  T? toData() => null;
  Map<String, dynamic> toJson();
  String get endpoint;
}
