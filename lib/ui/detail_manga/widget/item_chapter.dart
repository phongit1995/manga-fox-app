import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class ItemChapter extends StatelessWidget {
  final bool isRead;
  final bool isDownload;
  final String content;

  const ItemChapter(
      {Key? key,
      required this.isRead,
      required this.content,
      required this.isDownload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Row(
      children: [
        Expanded(
          child: Text(content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.mainStyle.copyWith(
                  color:
                      isRead ? const Color(0xffFF734A) : appColor.primaryBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 10)),
        ),
        SvgPicture.asset(!isDownload ? AppImage.icDownload : AppImage.icDelete)
      ],
    );
  }
}
