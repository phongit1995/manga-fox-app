import 'package:flutter/material.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_page.dart';
import 'package:manga_fox_app/ui/list_manga/widget/item_manga.dart';

class ListManga extends StatelessWidget {
  final List<Manga> mangas;

  const ListManga({Key? key, required this.mangas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Column(
      children: [
        ...mangas.map((e) => Column(
              children: [
                ItemMangaM(
                  title: e.name ?? "",
                  pathUrl: e.image ?? "",
                  viewCount: e.mapView(),
                  category: e.category ?? [],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailMangaPage(manga: e)),
                    );
                  },
                ),
                Divider(color: appColor.primaryDivider),
              ],
            ))
      ],
    );
  }
}
