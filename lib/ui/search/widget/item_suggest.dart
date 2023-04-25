import 'package:flutter/material.dart';
import 'package:manga_reader_app/core/app_config/app_style.dart';
import 'package:manga_reader_app/data/app_colors.dart';

class ItemSuggest extends StatelessWidget {
  final String content;

  const ItemSuggest({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).extension<AppColor>()!;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Text(
        content,
        style: AppStyle.mainStyle.copyWith(
            fontSize: 13, fontWeight: FontWeight.w400, color: const Color(0xff333333)),
      ),
    );
  }
}
