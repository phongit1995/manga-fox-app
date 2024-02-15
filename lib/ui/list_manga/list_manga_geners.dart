import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/list_manga/list_manga.dart';
import 'package:manga_fox_app/ui/search/search_controller.dart';

class ListMangaGeners extends StatefulWidget {
  final String title;
  final Generate? generate;
  final List<Manga>? mangas;

  const ListMangaGeners(
      {super.key, required this.title, this.mangas, this.generate});

  @override
  State<ListMangaGeners> createState() => _ListMangaGenersState();
}

class _ListMangaGenersState extends State<ListMangaGeners> {
  final _controller = SearchController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if(widget.mangas != null){
      _controller.results.value = widget.mangas ?? [];
    } else {
      _controller.loadCategoryManga(widget.generate?.name ?? "");
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _controller.loadMoreSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return Scaffold(
        backgroundColor: appColor.primaryBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 29),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset(
                          AppImage.icBack,
                          color: appColor.primaryBlack2,
                        ),
                      ),
                      Expanded(
                          child: Center(
                        child: Text(
                          widget.title,
                          style: AppStyle.mainStyle
                              .copyWith(color: appColor.primaryBlack2),
                        ),
                      )),
                      Opacity(
                          opacity: 0,
                          child: InkWell(
                            onTap: () {},
                            child: SvgPicture.asset(
                              AppImage.icSetting,
                              color: appColor.primaryBlack2,
                            ),
                          )),
                    ],
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isLoading,
                    builder: (context, isLoading, child) {
                      return ValueListenableBuilder(
                        valueListenable: _controller.results,
                        builder: (context, value, child) {
                          return Container(
                              margin: const EdgeInsets.only(top: 13),
                              child:
                                  ListManga(mangas: _controller.results.value));
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.loadMore,
                    builder: (context, isLoading, child) {
                      return Visibility(
                        visible: isLoading,
                        child: const SizedBox(
                          height: 40,
                          child: Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
