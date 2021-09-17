import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:transparent_image/transparent_image.dart';

class UserSearchDelegate extends SearchDelegate {
  final IUserRepository _userRepository = Modular.get<IUserRepository>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty)
            close(context, null);
          else {
            query = "";
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _userRepository.fetchSearch(query),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularLoading();
          default:
            if (snapshot.hasError || snapshot.data == null) {
              return Padding(
                padding: const PaddingScaffold(),
                child: Center(
                  child: _text(context: context, text: 'Nenhum resultado encontrado para "$query"'),
                ),
              );
            } else {
              UserModel model = snapshot.data!;
              return InkWell(
                onTap: () async => await Modular.to.pushNamed(USER_ROUTE, arguments: model),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: model.foto,
                        ).image,
                      ),
                      const HorizontalSizedBox(1.5),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.nome!,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            "@${model.username!}",
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const PaddingScaffold(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _text(context: context, text: "Encontre perfis de usuários"),
          const VerticalSizedBox(),
          Text(
            "Busque contas de usuários para assistir a suas Lives.",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _text({required BuildContext context, required String text}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
      textAlign: TextAlign.center,
    );
  }
}
