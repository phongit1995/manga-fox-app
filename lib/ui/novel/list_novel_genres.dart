import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/utils/handler_action.dart';
import 'package:manga_fox_app/core/widget/shimmer_loading.dart';
import 'package:manga_fox_app/data/response/novel_response.dart';
import 'package:manga_fox_app/ui/novel/detail/detail_page.dart';
import 'package:manga_fox_app/ui/novel/item_novel.dart';

class ListNovelGenres extends StatelessWidget {
  final List<Novel> novels;

  const ListNovelGenres({super.key, required this.novels});

  @override
  Widget build(BuildContext context) {
    if (novels.isEmpty) {
      return GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 200,
            crossAxisSpacing: 13,
            mainAxisSpacing: 13),
        itemCount: 12,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return ShimmerLoading(
            isLoading: novels.isEmpty,
            child: ItemNovel(
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
          crossAxisCount: 2,
          mainAxisExtent: 200,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13),
      itemCount: novels.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final novel = novels[index];
        return ItemNovel(
            title: novel.name ?? '',
            pathUrl: novel.image ?? '',
            viewCount: novel.mapView(),
            rate: novel.mapRate(),
            onTap: () {
              transferToDetail(context, novel);
            },
            isLoading: false);
      },
    );
  }

  transferToDetail(BuildContext context, Novel novel) {
    HandlerAction().handlerAction(() {
      DetailPage.transfer(
        context,
        novel: novel,
      );
    });
  }
}
