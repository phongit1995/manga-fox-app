import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/widget/header_content.dart';
import 'package:manga_fox_app/core/widget/search_widget.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/category_mock.dart';
import 'package:manga_fox_app/data/manga_mock.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_page.dart';
import 'package:manga_fox_app/ui/home/widget/item_category.dart';
import 'package:manga_fox_app/ui/home/widget/item_manga.dart';
import 'package:manga_fox_app/ui/search/search_page.dart';
import 'package:manga_fox_app/ui/user/user_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

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
            return Container(child: tab == 0 ? buildHome(context) : UserPage());
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
          Container(
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
                  ),
                  Expanded(
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: categoryMock.length,
                      itemBuilder: (context, index) {
                        var category = categoryMock[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 32),
                          child: ItemCategory(
                              pathUrl: category.path,
                              title: category.title,
                              onTap: () {}),
                        );
                      },
                    ),
                  )
                ],
              )),
          const SizedBox(height: 20),
          Container(
              height: 210,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  HeaderContent(
                    title: "Exclusively for you",
                    onMore: () {},
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: mangaMock.length,
                      itemBuilder: (context, index) {
                        var manga = mangaMock[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: ItemManga(
                              pathUrl: manga.pathUrl,
                              title: manga.title,
                              viewCount: manga.viewCount,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailMangaPage()),
                                );
                              }),
                        );
                      },
                    ),
                  )
                ],
              )),
          Container(
              height: 210,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  HeaderContent(
                    title: "Top Manga",
                    onMore: () {},
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: mangaMock.length,
                      itemBuilder: (context, index) {
                        var manga = mangaMock[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: ItemManga(
                              pathUrl: manga.pathUrl,
                              title: manga.title,
                              viewCount: manga.viewCount,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailMangaPage()),
                                );
                              }),
                        );
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
