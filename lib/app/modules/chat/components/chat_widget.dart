import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/chat/models/chat_model.dart';
import 'package:strapen_app/app/modules/chat/repositories/ichat_repository.dart';
import 'package:strapen_app/app/modules/chat/components/chat_tile.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';

class ChatWidget extends StatefulWidget {
  final ChatModel model;

  const ChatWidget({required this.model});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final IChatRepository _chatRepository = Modular.get<IChatRepository>();

  @override
  Widget build(BuildContext context) {
    return ParseLiveListWidget<ParseObject>(
      reverse: true,
      shrinkWrap: true,
      padding: const PaddingList(),
      query: _chatRepository.queryBuilder(widget.model.live!),
      childBuilder: (_, snapshot) {
        if (snapshot.failed) {
          return Center(
            child: Text(
              "Falha ao carregar os comentários!",
              style: Theme.of(context).textTheme.headline1,
            ),
          );
        } else if (snapshot.hasData) {
          return ChatTile(model: _chatRepository.toModel(snapshot.loadedData!));
        } else {
          return const CircularLoading();
        }
      },
    );
  }
}
