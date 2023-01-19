import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class ItemManga extends StatelessWidget {
  final String title;
  final String pathUrl;
  final String viewCount;
  final VoidCallback onTap;

  const ItemManga(
      {Key? key,
      required this.title,
      required this.pathUrl,
      required this.viewCount,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
            width: 80,
            height: 142,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    pathUrl,
                    width: 80,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 80,
                  height: 26,
                  child: Text(
                    title,
                    maxLines: 2,
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: appColor.primaryBlack),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 80,
                  child: Text(
                    viewCount,
                    maxLines: 1,
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        color: appColor.primaryBlack),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
