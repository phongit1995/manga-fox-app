import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class ItemCategory extends StatelessWidget {
  final String pathUrl;
  final String title;
  final VoidCallback onTap;
  final bool isLoading;

  const ItemCategory(
      {Key? key,
      required this.pathUrl,
      required this.title,
      required this.onTap,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    if (isLoading) {
      return SizedBox(
          width: 48,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 60,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black,
                ),
              )
            ],
          ));
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
            width: 48,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: pathUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 1,
                  style: AppStyle.mainStyle.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: appColor.primaryBlack),
                )
              ],
            )),
      ),
    );
  }
}
