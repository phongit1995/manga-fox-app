import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    var appColor = Theme.of(context).extension<AppColor>()!;
    if(!widget.isLoading) return widget.child;
    return Shimmer.fromColors(
      baseColor: appColor.shimmerLoadingBase,
      highlightColor: appColor.shimmerLoadingHighlight,
      enabled: widget.isLoading,
      child: widget.child,
    );
  }
}
