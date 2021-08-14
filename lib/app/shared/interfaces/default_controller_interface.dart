import 'dart:ui';

abstract class IDefaultController {
  late bool loading;
  VoidCallback? initPage;

  void setLoading(bool value);
  void setInitPage(VoidCallback function);
  Future<void> load();
}