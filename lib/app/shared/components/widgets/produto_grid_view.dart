import 'package:flutter/material.dart';

class ProdutoGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollPhysics physics;
  final bool aspectRatioWithStatus;

  const ProdutoGridView({
    required this.itemCount,
    required this.itemBuilder,
    this.physics = const NeverScrollableScrollPhysics(),
    this.aspectRatioWithStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: physics,
      shrinkWrap: true,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: aspectRatioWithStatus ? 0.61 : 0.70,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
