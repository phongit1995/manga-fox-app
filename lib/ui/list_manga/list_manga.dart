import 'package:flutter/material.dart';
import 'package:manga_reader_app/core/utils/handler_action.dart';
import 'package:manga_reader_app/core/widget/separator.dart';
import 'package:manga_reader_app/core/widget/shimmer_loading.dart';
import 'package:manga_reader_app/data/app_colors.dart';
import 'package:manga_reader_app/data/response/manga_response.dart';
import 'package:manga_reader_app/ui/detail_manga/detail_manga_page.dart';
import 'package:manga_reader_app/ui/list_manga/widget/item_manga.dart';

class ListManga extends StatelessWidget {
  final List<Manga> mangas;

  const ListManga({Key? key, required this.mangas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Column(
      children: [
        if (mangas.isEmpty)
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ShimmerLoading(
                  isLoading: true,
                  child: ItemMangaM(
                    isLoading: true,
                    title: "",
                    pathUrl: "",
                    viewCount: '',
                    category: [],
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
        ...mangas.map((e) => Column(
              children: [
                ItemMangaM(
                  isLoading: false,
                  title: e.name ?? "",
                  pathUrl: e.image ?? "",
                  viewCount: "${e.mapView()} Views",
                  category: e.category ?? [],
                  onTap: () {
                    HandlerAction().handlerAction(() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailMangaPage(manga: e)),
                        ));
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 7, top: 7),
                  child: const Separator(),),
              ],
            ))
      ],
    );
  }
}
