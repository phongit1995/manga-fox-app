import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/ui/library/library_controller.dart';
import 'package:manga_fox_app/ui/library/library_dowload.dart';
import 'package:manga_fox_app/ui/library/library_favorite.dart';
import 'package:manga_fox_app/ui/library/library_history.dart';

class LibraryPage extends StatefulWidget {
  LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final controller = LibraryController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: appColor.primaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 300,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appColor.backgroundTabBar,
                  ),
                  child: TabBar(
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    unselectedLabelColor: appColor.primaryBlack2,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelStyle: AppStyle.mainStyle
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffFF734A)),
                    tabs: const [
                      Tab(text: "Favorite"),
                      Tab(text: "Download"),
                      Tab(text: "History"),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  LibraryFavorite(),
                  LibraryDownload(),
                  LibraryHistory(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
