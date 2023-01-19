import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';

class ItemCategoryM extends StatelessWidget {
  final String content;
  final VoidCallback onTap;

  const ItemCategoryM({Key? key, required this.content, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: const Color(0xffFF734A),
                borderRadius: BorderRadius.circular(3)),
            child: Text(
              content,
              style: AppStyle.mainStyle.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          )),
    );
  }
}
