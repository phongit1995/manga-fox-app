import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/widget/search_widget.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/category_mock.dart';
import 'package:manga_fox_app/ui/list_manga/list_manga.dart';
import 'package:manga_fox_app/ui/search/widget/item_suggest.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  final mock = <String>[
    "Action",
    "ANIME L",
    "sogoku sogoku",
    "Action sssss",
    "ANIME SHI",
    "sog",
    "Act cx dion",
    "ANIME rrr ff f",
    "sogoku 944",
    "Action Hs",
    "ANIME ff",
    "sogoku ffdf",
    "Action 00990",
    "ANIME SHo",
    "sogoku Ss"
  ];


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return Scaffold(
        backgroundColor: appColor.primaryBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 29),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: SearchWidget(controller: controller)),
                      const SizedBox(width: 18),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              alignment: Alignment.centerRight),
                          child: Container(
                            width: 63,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffFF734A)),
                            child: Text(
                              "Cancel",
                              style: AppStyle.mainStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10),
                            ),
                          ))
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      return controller.text.trim().isEmpty
                          ? Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: buildSuggest(context))
                          : Container(
                              margin: const EdgeInsets.only(top: 13),
                              child: const ListManga());
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildSuggest(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "History",
            style: AppStyle.mainStyle.copyWith(
                fontSize: 12,
                color: appColor.primaryBlack,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          children: [
            ...mock.map((e) => Container(
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                child: ItemSuggest(content: e)))
          ],
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Categories",
            style: AppStyle.mainStyle.copyWith(
                fontSize: 12,
                color: appColor.primaryBlack,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          children: [
            ...categoryMock.map((e) => Container(
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                child: ItemSuggest(content: e.title)))
          ],
        )
      ],
    );
  }
}
