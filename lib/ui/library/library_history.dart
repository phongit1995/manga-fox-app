import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/manga_mock.dart';
import 'package:manga_fox_app/ui/library/bottom_sheet_setting_more_option.dart';

class LibraryHistory extends StatelessWidget {
  const LibraryHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "History Books",
              style: AppStyle.mainStyle.copyWith(
                  color: appColor.primaryBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          ...mangaMock.map((e) {
            return Column(
              children: [
                _buildItem(context, e),
                Container(
                  margin: const EdgeInsets.only(left: 107, right: 20),
                  child: Divider(color: appColor.primaryDivider),
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, Manga manga) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return InkWell(
      onTap: () {},
      child: Container(
        height: 80,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                manga.pathUrl,
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
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "Adventure",
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: appColor.primaryBlack),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    manga.title,
                    maxLines: 2,
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: appColor.primaryBlack),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    manga.viewCount,
                    maxLines: 1,
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: appColor.primaryBlack),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: appColor.backgroundWhite2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return const BottomSheetSettingMoreOption();
                  },
                );
              },
              child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: appColor.primaryBlack2,
                    size: 12,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
