import 'package:flutter/material.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/manga_mock.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_page.dart';
import 'package:manga_fox_app/ui/list_manga/widget/item_manga.dart';

class ListManga extends StatelessWidget {
  const ListManga({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Column(
      children: [
        ...mangaMock.map((e) => Column(
              children: [
                ItemMangaM(
                  title: e.title,
                  pathUrl: e.pathUrl,
                  viewCount: e.viewCount,
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => DetailMangaPage()),
                    // );
                  },
                ),
                Divider(color: appColor.primaryDivider),
              ],
            ))
      ],
    );
  }
}
