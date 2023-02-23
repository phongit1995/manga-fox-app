import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class ItemManga extends StatelessWidget {
  final String title;
  final String pathUrl;
  final String viewCount;
  final bool isLoading;
  final VoidCallback onTap;

  const ItemManga(
      {Key? key,
      required this.title,
      required this.pathUrl,
      required this.viewCount,
      required this.onTap,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    if (isLoading) {
      return SizedBox(
          width: 80,
          height: 142,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: 80,
                  height: 100,
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
            width: 80,
            height: 142,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: pathUrl,
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
