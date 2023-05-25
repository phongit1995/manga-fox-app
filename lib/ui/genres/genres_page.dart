import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/utils/handler_action.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/genres/genres_controller.dart';
import 'package:manga_fox_app/ui/genres/widget/list_manga_genres.dart';
import 'package:manga_fox_app/ui/home/home_controller.dart';
import 'package:manga_fox_app/ui/search/search_page.dart';

class GenresPage extends StatefulWidget {
  const GenresPage({super.key});

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  final HandlerAction appAction = HandlerAction();
  final homeController = HomeController();
  final _controller = GenresController();
  final tabIndex = ValueNotifier<int>(0);
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _controller.loadMoreCategoryManga();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return Scaffold(
        backgroundColor: appColor.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Genres",
              style: AppStyle.mainStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  color: appColor.primary)),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                appAction.handlerAction(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SvgPicture.asset(AppImage.icSearch),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ValueListenableBuilder<List<Generate>>(
              valueListenable: homeController.generates,
              builder: (context, generes, child) {
                final i = generes.indexWhere(
                    (element) => element.name == _controller.genres.value);
                if (i < 0 && generes.isNotEmpty) {
                  _controller.genres.value = generes.first.name ?? '';
                  _controller.loadMangas(generes.first.name ?? '');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTabController(
                        length: generes.length,
                        initialIndex: i >= 0 ? i : 0,
                        child: TabBar(
                          isScrollable: true,
                          onTap: (value) async {
                            _controller.mangas.value = [];
                            _controller.genresSelect.value =
                                generes[value].name ?? '';
                            await _controller
                                .loadMangas(generes[value].name ?? '');
                          },
                          indicatorColor: appColor.primary,
                          labelStyle: AppStyle.mainStyle.copyWith(
                              color: appColor.primaryBlack2,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          labelColor: appColor.primary,
                          unselectedLabelColor: appColor.primaryBlack2,
                          indicator: UnderlineTabIndicator(
                              borderSide:
                                  BorderSide(width: 1, color: appColor.primary),
                              insets: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 2)),
                          unselectedLabelStyle: AppStyle.mainStyle.copyWith(
                              color: appColor.primaryBlack2,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          tabs: List.generate(generes.length,
                              (index) => Text(generes[index].name ?? '')),
                        )),
                    Container(height: 20),
                    Expanded(
                      child: ValueListenableBuilder<List<Manga>>(
                        builder: (context, value, child) => ListMangaGenres(
                          mangas: value,
                          scroll: scrollController,
                          lastList: ValueListenableBuilder<bool>(
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
                        ),
                        valueListenable: _controller.mangas,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
