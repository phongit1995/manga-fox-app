import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/novel_chapter.dart';

class ItemNovelChapter extends StatelessWidget {
  final bool isRead;
  final NovelChapter chapter;

  const ItemNovelChapter(
      {Key? key,
      required this.isRead,
      required this.chapter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chapter.title ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.mainStyle.copyWith(
                      color: isRead
                          ? const Color(0xffFF734A)
                          : appColor.primaryBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 13)),
              const SizedBox(height: 6),
              Text(chapter.getDateCreates,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.mainStyle.copyWith(
                      color: const Color(0xff828282),
                      fontWeight: FontWeight.w500,
                      fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
