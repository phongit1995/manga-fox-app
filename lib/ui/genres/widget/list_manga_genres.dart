import 'package:flutter/material.dart';
import 'package:manga_reader_app/core/utils/handler_action.dart';
import 'package:manga_reader_app/core/widget/shimmer_loading.dart';
import 'package:manga_reader_app/data/response/manga_response.dart';
import 'package:manga_reader_app/ui/detail_manga/detail_manga_page.dart';

import 'item_manga.dart';

class ListMangaGenres extends StatelessWidget {
  final List<Manga> mangas;

  const ListMangaGenres({super.key, required this.mangas});

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
    return GridView.builder(
      scrollDirection: Axis.vertical,
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
