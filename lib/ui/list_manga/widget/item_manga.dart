import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/category_mock.dart';
import 'package:manga_fox_app/ui/list_manga/widget/item_category.dart';

class ItemMangaM extends StatelessWidget {
  final String title;
  final String pathUrl;
  final String viewCount;
  final VoidCallback onTap;

  const ItemMangaM(
      {Key? key,
      required this.title,
      required this.pathUrl,
      required this.viewCount,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          pathUrl,
          width: 80,
          height: 100,
          fit: BoxFit.fill,
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              style: AppStyle.mainStyle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: appColor.primaryBlack),
            ),
            const SizedBox(height: 8),
            Text(
              viewCount,
              maxLines: 1,
              style: AppStyle.mainStyle.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: appColor.primaryBlack),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: [
                ...categoryMock.map((e) => Container(
                    margin: const EdgeInsets.only(right: 4, bottom: 8),
                    child: ItemCategoryM(
                      content: e.title,
                      onTap: () {},
                    )))
              ],
            )
          ],
        ),
      )
        ],
      ),
    );
  }
}
