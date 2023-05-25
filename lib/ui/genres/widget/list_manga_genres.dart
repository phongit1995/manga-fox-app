import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/utils/handler_action.dart';
import 'package:manga_fox_app/core/widget/shimmer_loading.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_page.dart';

import 'item_manga.dart';

class ListMangaGenres extends StatelessWidget {
  final List<Manga> mangas;
  final ScrollController scroll;
  final Widget lastList;

  const ListMangaGenres({super.key, required this.mangas, required this.scroll, required this.lastList});

  @override
  Widget build(BuildContext context) {
    if (mangas.isEmpty) {
      return GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 200,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4),
        itemCount: 12,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return ShimmerLoading(
            isLoading: mangas.isEmpty,
            child: ItemManga(
                title: '',
                pathUrl: '',
                rate: '',
                viewCount: '',
                onTap: () {},
                isLoading: true),
          );
        },
      );
    }
    return SingleChildScrollView(
      controller: scroll,
      child: Column(
        children: [
          GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 200,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4),
            itemCount: mangas.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final manga = mangas[index];
              return ItemManga(
                  title: manga.name ?? '',
                  pathUrl: manga.image ?? '',
                  viewCount: manga.mapView(),
                  rate: manga.mapRate(),
                  onTap: () {
                    transferToDetailManga(context, manga);
                  },
                  isLoading: false);
            },
          ),
          lastList
        ],
      ),
    );
  }

  transferToDetailManga(BuildContext context, Manga manga) {
    HandlerAction().handlerAction(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailMangaPage(
                  manga: manga,
                )),
      );
    });
  }
}
