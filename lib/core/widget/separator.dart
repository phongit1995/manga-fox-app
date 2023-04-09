import 'package:flutter/material.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class Separator extends StatelessWidget {
  const Separator({Key? key, this.height = 0.5, this.color})
      : super(key: key);
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).extension<AppColor>()!;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color ?? appColor.primaryDivider),
              ),
            );
          }),
        );
      },
    );
  }
}
