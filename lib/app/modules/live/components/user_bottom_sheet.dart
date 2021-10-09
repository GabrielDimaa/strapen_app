import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/pages/user_page.dart';

class UserBottomSheet extends StatefulWidget {
  final BuildContext context;
  final UserModel user;

  const UserBottomSheet({required this.context, required this.user});

  @override
  _UserBottomSheetState createState() => _UserBottomSheetState();

  static Future<void> show({required BuildContext context, required UserModel user}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => UserBottomSheet(
        context: context,
        user: user,
      ),
    );
  }
}

class _UserBottomSheetState extends State<UserBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(widget.context).padding.top),
      child: UserPage(model: widget.user),
    );
  }
}
