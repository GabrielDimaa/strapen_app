import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';

class CatalogoGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const CatalogoGridView({required this.itemCount, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ((MediaQuery.of(context).size.width - (PaddingScaffold.value * 2)) ~/  130),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
