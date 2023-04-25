import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manga_reader_app/core/app_config/app_image.dart';
import 'package:manga_reader_app/core/app_config/app_style.dart';
import 'package:manga_reader_app/data/app_colors.dart';

class HeaderContent extends StatelessWidget {
  final String title;
  final VoidCallback onMore;
  final bool? isShowMore;
  final Widget? iconLeft;

  const HeaderContent(
      {Key? key,
      required this.title,
      required this.onMore,
      this.isShowMore,
      this.iconLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: iconLeft,
        ),
        Text(
          title,
          style: AppStyle.mainStyle.copyWith(
              color: appColor.primaryBlack,
              fontWeight: FontWeight.w600,
              fontSize: 15),
        ),
        const Spacer(),
        Opacity(
          opacity: isShowMore != false ? 1 : 0,
          child: TextButton(
              onPressed: onMore,
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, alignment: Alignment.centerRight),
              child: Row(
                children: [
                  Text(
                    "See all",
                    style: AppStyle.mainStyle.copyWith(
                        color: appColor.primaryBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    AppImage.icArrowMore,
                    color: appColor.primaryBlack,
                  )
                ],
              )),
        )
      ],
    );
  }
}
