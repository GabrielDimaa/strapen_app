import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';

class ProdutoGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollPhysics? physics;
  final bool aspectRatioWithStatus;

  const ProdutoGridView({
    required this.itemCount,
    required this.itemBuilder,
    this.physics,
    this.aspectRatioWithStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: physics,
      shrinkWrap: true,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ((MediaQuery.of(context).size.width - (PaddingScaffold.value * 2)) ~/  130),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: aspectRatioWithStatus ? 0.60 : 0.68,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
