import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/chat/repositories/chat_repository.dart';

class ChatModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ChatRepository())
  ];
}