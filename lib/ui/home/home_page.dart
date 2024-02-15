import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/applovin.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/app_setting.dart';
import 'package:manga_fox_app/core/utils/handler_action.dart';
import 'package:manga_fox_app/core/widget/header_content.dart';
import 'package:manga_fox_app/core/widget/search_widget.dart';
import 'package:manga_fox_app/core/widget/shimmer_loading.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_page.dart';
import 'package:manga_fox_app/ui/genres/genres_page.dart';
import 'package:manga_fox_app/ui/home/home_controller.dart';
import 'package:manga_fox_app/ui/home/widget/banner.dart';
import 'package:manga_fox_app/ui/home/widget/item_manga.dart';
import 'package:manga_fox_app/ui/library/library_page.dart';
import 'package:manga_fox_app/ui/list_manga/list_manga_geners.dart';
import 'package:manga_fox_app/ui/novel/novel_page.dart';
import 'package:manga_fox_app/ui/search/search_page.dart';
import 'package:manga_fox_app/ui/user/in_app_page.dart';
import 'package:manga_fox_app/ui/user/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final HomeController _controller = HomeController();
  final HandlerAction appAction = HandlerAction();

  @override
  void initState() {
    super.initState();
    _controller.loadBannerManga();
    _controller.loadGenerate();
    _controller.loadLastManga();
    _controller.loadTopManga();
    _controller.loadExManga();
  }

  final bottomNav = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        label: 'Homepage',
        icon: SvgPicture.asset(AppImage.icHomeDefault),
        activeIcon: SvgPicture.asset(AppImage.icHomeActive)),
    BottomNavigationBarItem(
        label: 'Genres',
        icon: SvgPicture.asset(AppImage.icGenresDefault),
        activeIcon: SvgPicture.asset(AppImage.icGenresActive)),
    BottomNavigationBarItem(
        label: 'Novel',
        icon: SvgPicture.asset(AppImage.icNovelDefault),
        activeIcon: SvgPicture.asset(AppImage.icNovelActive)),
    BottomNavigationBarItem(
      label: 'Library',
      icon: SvgPicture.asset(AppImage.icLibraryDefault),
      activeIcon: SvgPicture.asset(AppImage.icLibraryActive),
    ),
    BottomNavigationBarItem(
      label: 'User',
      icon: SvgPicture.asset(AppImage.icUserDefault),
      activeIcon: SvgPicture.asset(AppImage.icUserActive),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
        backgroundColor: appColor.primaryBackground,
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: currentIndex,
          builder: (context, value, child) => BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            unselectedLabelStyle: AppStyle.mainStyle,
            items: bottomNav,
            currentIndex: currentIndex.value,
            unselectedItemColor: const Color(0xff4B526C),
            selectedItemColor: appColor.primary,
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
                        ? const GenresPage()
                        : tab == 2
                            ? const NovelPage()
                            : tab == 3
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
                      appAction.handlerAction(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchPage()),
                        );
                      });
                    },
                    child: const SearchWidget(
                      isOnlyTap: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ValueListenableBuilder<bool>(
                    valueListenable: AppSettingData().userPremium,
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const InAppPage()));
                        },
                        child: Visibility(
                            visible: !value,
                            child: Container(
                              height: 44,
                              width: 83,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: const LinearGradient(colors: [
                                    Color(0xffFF9171),
                                    Color(0xffFF5E5E),
                                  ])),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppImage.icDiamond),
                                  const SizedBox(width: 8),
                                  Text(
                                    "V.I.P",
                                    style: AppStyle.mainStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  )
                                ],
                              ),
                            )),
                      );
                    }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          banner(),
          const SizedBox(height: 14),
          topUpdate(),
          lastUpdate(),
          exfy(),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  banner() {
    return ValueListenableBuilder<List<Manga>>(
      valueListenable: _controller.bannerManga,
      builder: (context, mangas, child) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BannerWidget(
            mangas: mangas,
          )),
    );
  }

  exfy() {
    return ValueListenableBuilder<List<Manga>>(
      valueListenable: _controller.exManga,
      builder: (context, exManga, child) => Container(
          height: 230,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              HeaderContent(
                title: "Exclusively for you",
                onMore: () {
                  applovinServiceAds.showInterstital();
                  appAction.handlerAction(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListMangaGeners(
                                mangas: exManga,
                                title: "Exclusively for you",
                              )),
                    );
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: exManga.isEmpty
                      ? 10
                      : exManga.length > 20
                          ? 20
                          : exManga.length,
                  itemBuilder: (context, index) {
                    var manga = exManga.isEmpty ? Manga() : exManga[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: ShimmerLoading(
                        isLoading: exManga.isEmpty,
                        child: ItemManga(
                            pathUrl: manga.image ?? "",
                            title: manga.name ?? "",
                            rate: manga.mapRate(),
                            viewCount: manga.mapView(),
                            onTap: () {
                              transferToDetailManga(manga);
                            },
                            isLoading: exManga.isEmpty),
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }

  topUpdate() {
    return ValueListenableBuilder<List<Manga>>(
      valueListenable: _controller.topManga,
      builder: (context, topManga, child) => Container(
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              HeaderContent(
                title: "Hot Manga",
                iconLeft: SvgPicture.asset(AppImage.icHotManga),
                onMore: () {
                  appAction.handlerAction(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListMangaGeners(
                                mangas: topManga,
                                title: "Hot Manga",
                              )),
                    );
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topManga.isEmpty
                      ? 10
                      : topManga.length > 20
                          ? 20
                          : topManga.length,
                  itemBuilder: (context, index) {
                    var manga = topManga.isEmpty ? Manga() : topManga[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: ShimmerLoading(
                        isLoading: topManga.isEmpty,
                        child: ItemManga(
                            pathUrl: manga.image ?? "",
                            title: manga.name ?? "",
                            rate: manga.mapRate(),
                            viewCount: manga.mapView(),
                            onTap: () {
                              transferToDetailManga(manga);
                            },
                            isLoading: topManga.isEmpty),
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }

  lastUpdate() {
    return ValueListenableBuilder<List<Manga>>(
      valueListenable: _controller.lastManga,
      builder: (context, lastManga, child) => Container(
          height: 260,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              HeaderContent(
                title: "Last Update",
                iconLeft: SvgPicture.asset(AppImage.icLastManga),
                onMore: () {
                  appAction.handlerAction(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListMangaGeners(
                                mangas: lastManga,
                                title: "Last Update",
                              )),
                    );
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: lastManga.isEmpty
                      ? 10
                      : lastManga.length > 20
                          ? 20
                          : lastManga.length,
                  itemBuilder: (context, index) {
                    var manga = lastManga.isEmpty ? Manga() : lastManga[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: ShimmerLoading(
                        isLoading: lastManga.isEmpty,
                        child: ItemManga(
                            isLoading: lastManga.isEmpty,
                            pathUrl: manga.image ?? "",
                            rate: manga.mapRate(),
                            title: manga.name ?? "",
                            viewCount: manga.mapView(),
                            onTap: () {
                              transferToDetailManga(manga);
                            }),
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }

  transferToDetailManga(Manga manga) {
    appAction.handlerAction(() {
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
