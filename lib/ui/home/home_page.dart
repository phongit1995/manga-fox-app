import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/widget/header_content.dart';
import 'package:manga_fox_app/core/widget/search_widget.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_page.dart';
import 'package:manga_fox_app/ui/home/home_controller.dart';
import 'package:manga_fox_app/ui/home/widget/item_category.dart';
import 'package:manga_fox_app/ui/home/widget/item_manga.dart';
import 'package:manga_fox_app/ui/library/library_page.dart';
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
                const SizedBox(width: 18),
                SvgPicture.asset(AppImage.icVip)
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
                child: generates.isEmpty
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
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
                              itemCount: generates.length,
                              itemBuilder: (context, index) {
                                var category = generates[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 32),
                                  child: ItemCategory(
                                      pathUrl: category.image ?? "",
                                      title: category.name ?? "",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SearchPage(
                                                  category:
                                                      category.name ?? "")),
                                        );
                                      }),
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
                      onMore: () {},
                    ),
                    Expanded(
                      child: exManga.isEmpty
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: exManga.length,
                              itemBuilder: (context, index) {
                                var manga = exManga[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: ItemManga(
                                      pathUrl: manga.image ?? "",
                                      title: manga.name ?? "",
                                      viewCount: manga.mapView(),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailMangaPage(
                                                      manga: manga)),
                                        );
                                      }),
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
                      onMore: () {},
                    ),
                    Expanded(
                      child: topManga.isEmpty
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: topManga.length,
                              itemBuilder: (context, index) {
                                var manga = topManga[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: ItemManga(
                                      pathUrl: manga.image ?? "",
                                      title: manga.name ?? "",
                                      viewCount: manga.mapView(),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailMangaPage(
                                                      manga: manga)),
                                        );
                                      }),
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
                      onMore: () {},
                    ),
                    Expanded(
                      child: lastManga.isEmpty
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: lastManga.length,
                              itemBuilder: (context, index) {
                                var manga = lastManga[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: ItemManga(
                                      pathUrl: manga.image ?? "",
                                      title: manga.name ?? "",
                                      viewCount: manga.mapView(),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailMangaPage(
                                                    manga: manga,
                                                  )),
                                        );
                                      }),
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
