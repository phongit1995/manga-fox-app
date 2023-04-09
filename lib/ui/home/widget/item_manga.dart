import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class ItemManga extends StatelessWidget {
  final String title;
  final String pathUrl;
  final String rate;
  final String viewCount;
  final bool isLoading;
  final VoidCallback onTap;

  const ItemManga(
      {Key? key,
      required this.title,
      required this.pathUrl,
      required this.viewCount,
      required this.onTap,
      required this.isLoading,
      required this.rate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    if (isLoading) {
      return SizedBox(
          width: 103,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: 103,
                  height: 129,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black,
                  ),
                  width: 60,
                  height: 10),
              const SizedBox(height: 4),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black,
                  ),
                  width: 40,
                  height: 10),
            ],
          ));
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
            width: 103,
            height: 200,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: pathUrl,
                    width: 103,
                    height: 129,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 103,
                  height: 30,
                  child: Text(
                    title,
                    maxLines: 2,
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: appColor.primaryBlack),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 103,
                  child: Row(
                    children: [
                      Text(
                        "$viewCount Views",
                        maxLines: 1,
                        style: AppStyle.mainStyle.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: appColor.primaryBlack3),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Text(
                          rate,
                          maxLines: 1,
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: appColor.yellow),
                        ),
                      ),
                      const SizedBox(width: 2),
                      SvgPicture.asset(AppImage.icStarYellow)
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
