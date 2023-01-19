import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';

class ItemSuggest extends StatelessWidget {
  final String content;

  const ItemSuggest({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Text(
        content,
        style: AppStyle.mainStyle.copyWith(
            fontSize: 10, fontWeight: FontWeight.w300, color: Colors.black),
      ),
    );
  }
}
