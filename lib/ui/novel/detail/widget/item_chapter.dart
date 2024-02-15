import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';

class ItemChapter extends StatelessWidget {
  final bool isRead;
  final bool isDownload;
  final bool isLoading;
  final ListChapter chapter;
  final VoidCallback onDownload;

  const ItemChapter(
      {Key? key,
      required this.isRead,
      required this.chapter,
      required this.isDownload,
      required this.onDownload,
      required this.isLoading})
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
              Text(chapter.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.mainStyle.copyWith(
                      color:
                          isRead ? const Color(0xffFF734A) : appColor.primaryBlack,
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
        Container(
          height: 32,
          width: 40,
          child: Visibility(
            visible: !isLoading,
            child: InkWell(
              onTap: onDownload,
              child: SvgPicture.asset(
                  !isDownload ? AppImage.icDownload : AppImage.icDelete),
            ),
          ),
        )
      ],
    );
  }
}
