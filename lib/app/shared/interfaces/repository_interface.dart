import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

abstract class IRepository<T> {
  String className();
  void validate(T model);
  ParseObject toParseObject(T model);
  T toModel(ParseObject e);
}