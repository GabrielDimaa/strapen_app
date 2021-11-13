import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/configuracoes/controllers/configuracoes_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/button/outlined_button_default.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';

class ConfiguracoesPage extends StatefulWidget {
  @override
  _ConfiguracoesPageState createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends ModularState<ConfiguracoesPage, ConfiguracoesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Configurações"),
      ),
      body: Padding(
        padding: const PaddingScaffold(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _itemList(
                    icon: Icons.person,
                    label: "Meu perfil",
                    onTap: () async => await controller.toMeuPerfil(),
                  ),
                  _itemList(
                    icon: Icons.phonelink_lock,
                    label: "Editar dados pessoais",
                    onTap: () async => await controller.toEditarDadosPessoais(),
                  ),
                  _itemList(
                    icon: Icons.lock,
                    label: "Alterar senha",
                    onTap: () async => await controller.toAlterarSenha(),
                  ),
                ],
              ),
            ),
            OutlinedButtonDefault(
              onPressed: () async => await controller.logout(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: AppColors.primary),
                  const HorizontalSizedBox(1.5),
                  Text(
                    "Sair",
                    style: Theme.of(context).textTheme.button!.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemList({required IconData icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(0),
          title: Row(
            children: [
              Icon(icon),
              const HorizontalSizedBox(1.5),
              Text(label),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
        Divider(color: Colors.white.withOpacity(0.5)),
      ],
    );
  }
}
