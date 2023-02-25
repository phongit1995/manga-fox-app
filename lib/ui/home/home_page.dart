import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/widget/header_content.dart';
import 'package:manga_fox_app/core/widget/search_widget.dart';
import 'package:manga_fox_app/core/widget/shimmer_loading.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_page.dart';
import 'package:manga_fox_app/ui/home/home_controller.dart';
import 'package:manga_fox_app/ui/home/widget/item_category.dart';
import 'package:manga_fox_app/ui/home/widget/item_manga.dart';
import 'package:manga_fox_app/ui/library/library_page.dart';
import 'package:manga_fox_app/ui/list_manga/list_manga_geners.dart';
import 'package:manga_fox_app/ui/search/search_page.dart';
import 'package:manga_fox_app/ui/user/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _controller.loadGenerate();
    _controller.loadLastManga();
    _controller.loadTopManga();
    _controller.loadExManga();
  }

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
        backgroundColor: appColor.primaryBackground,
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: currentIndex,
          builder: (context, value, child) => BottomNavigationBar(
            backgroundColor: appColor.backgroundBottomNavigator,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  label: 'Homepage',
                  icon: SvgPicture.asset(AppImage.icHomeDefault,
                      color: appColor.activeBottomNavigator),
                  activeIcon: SvgPicture.asset(AppImage.icHomeActive,
                      color: appColor.activeBottomNavigator)),
              BottomNavigationBarItem(
                label: 'Library',
                icon: SvgPicture.asset(AppImage.icLibraryDefault,
                    color: appColor.activeBottomNavigator),
                activeIcon: SvgPicture.asset(AppImage.icLibraryActive,
                    color: appColor.activeBottomNavigator),
              ),
              BottomNavigationBarItem(
                label: 'User',
                icon: SvgPicture.asset(AppImage.icUserDefault,
                    color: appColor.activeBottomNavigator),
                activeIcon: SvgPicture.asset(AppImage.icUserActive,
                    color: appColor.activeBottomNavigator),
              ),
            ],
            currentIndex: currentIndex.value,
            unselectedItemColor: appColor.activeBottomNavigator,
            selectedItemColor: appColor.activeBottomNavigator,
            onTap: (value) {
              currentIndex.value = value;
            },
          ),
        ),
        body: SafeArea(
            child: ValueListenableBuilder<int>(
          builder: (context, tab, child) {
            return Container(
                child: tab == 0
                    ? buildHome(context)
                    : tab == 1
                        ? LibraryPage()
                        : const UserPage());
          },
          valueListenable: currentIndex,
        )));
  }

  buildHome(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 29),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()),
                      );
                    },
                    child: const SearchWidget(
                      isOnlyTap: true,
                    ),
                  ),
                ),
                // const SizedBox(width: 18),
                // SvgPicture.asset(AppImage.icVip)
              ],
            ),
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<List<Generate>>(
            valueListenable: _controller.generates,
            builder: (context, generates, child) => Container(
                height: 208,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: appColor.backgroundWhite,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    HeaderContent(
                      title: "Categories",
                      onMore: () {},
                      isShowMore: false,
                    ),
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: generates.isEmpty ? 10 : generates.length,
                        itemBuilder: (context, index) {
                          var category =
                              generates.isEmpty ? Generate() : generates[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 32),
                            child: ShimmerLoading(
                              isLoading: generates.isEmpty,
                              child: ItemCategory(
                                  pathUrl: category.image ?? "",
                                  title: category.name ?? "",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListMangaGeners(
                                            title: category.name ?? "",
                                            generate: category,
                                          )),
                                    );
                                  },
                                  isLoading: generates.isEmpty),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<List<Manga>>(
            valueListenable: _controller.exManga,
            builder: (context, exManga, child) => Container(
                height: 210,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    HeaderContent(
                      title: "Exclusively for you",
                      onMore: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListMangaGeners(
                                mangas: exManga,
                                title: "Exclusively for you",
                              )),
                        );
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: exManga.isEmpty ? 10 : exManga.length,
                        itemBuilder: (context, index) {
                          var manga =
                              exManga.isEmpty ? Manga() : exManga[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: ShimmerLoading(
                              isLoading: exManga.isEmpty,
                              child: ItemManga(
                                  pathUrl: manga.image ?? "",
                                  title: manga.name ?? "",
                                  viewCount: manga.mapView(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailMangaPage(manga: manga)),
                                    );
                                  },
                                  isLoading: exManga.isEmpty),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )),
          ),
          ValueListenableBuilder<List<Manga>>(
            valueListenable: _controller.topManga,
            builder: (context, topManga, child) => Container(
                height: 210,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    HeaderContent(
                      title: "Top Manga",
                      onMore: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListMangaGeners(
                                mangas: topManga,
                                title: "Top Manga",
                              )),
                        );
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topManga.isEmpty ? 10 : topManga.length,
                        itemBuilder: (context, index) {
                          var manga =
                              topManga.isEmpty ? Manga() : topManga[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: ShimmerLoading(
                              isLoading: topManga.isEmpty,
                              child: ItemManga(
                                  pathUrl: manga.image ?? "",
                                  title: manga.name ?? "",
                                  viewCount: manga.mapView(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailMangaPage(manga: manga)),
                                    );
                                  },
                                  isLoading: topManga.isEmpty),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )),
          ),
          ValueListenableBuilder<List<Manga>>(
            valueListenable: _controller.lastManga,
            builder: (context, lastManga, child) => Container(
                height: 210,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    HeaderContent(
                      title: "Lastest Update",
                      onMore: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListMangaGeners(
                                    mangas: lastManga,
                                    title: "Lastest Update",
                                  )),
                        );
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: lastManga.isEmpty ? 10 : lastManga.length,
                        itemBuilder: (context, index) {
                          var manga =
                              lastManga.isEmpty ? Manga() : lastManga[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: ShimmerLoading(
                              isLoading: lastManga.isEmpty,
                              child: ItemManga(
                                  isLoading: lastManga.isEmpty,
                                  pathUrl: manga.image ?? "",
                                  title: manga.name ?? "",
                                  viewCount: manga.mapView(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailMangaPage(
                                                manga: manga,
                                              )),
                                    );
                                  }),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
