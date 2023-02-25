import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/widget/search_widget.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/ui/home/home_controller.dart';
import 'package:manga_fox_app/ui/list_manga/list_manga.dart';
import 'package:manga_fox_app/ui/list_manga/list_manga_geners.dart';
import 'package:manga_fox_app/ui/search/search_controller.dart';
import 'package:manga_fox_app/ui/search/widget/item_suggest.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  final _controller = SearchController();
  final HomeController _controllerHome = HomeController();

  @override
  void initState() {
    super.initState();
    _controller.getSearchHistory();
  }

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
                      Expanded(
                          child: SearchWidget(
                            controller: controller,
                            onSubmit: (p0) async {
                              await _controller.search(p0);
                              _controller.setSearchHistory(p0);
                            },
                          )),
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
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isLoading,
                    builder: (context, isLoading, child) {
                      return ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (context, txt, child) {
                          if (controller.text
                              .trim()
                              .isEmpty) {
                            _controller.results.value.clear();
                            _controller.results.value =
                                _controller.results.value;

                          }
                          return ValueListenableBuilder(
                            valueListenable: _controller.results,
                            builder: (context, value, child) {
                              if(!isLoading && _controller.results.value.isEmpty) {
                                return buildSuggest(context);
                              }
                              return Container(
                                  margin: const EdgeInsets.only(top: 13),
                              child: ListManga(
                              mangas: _controller.results.value
                              ));
                            },
                          );
                        },
                      );
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
        ValueListenableBuilder<List<String>>(
          valueListenable: _controller.searchHistory,
          builder: (context, value, child) =>
              Visibility(
                visible: value.isNotEmpty,
                child: Column(
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
                        ...value.map((e) =>
                            Container(
                                margin: const EdgeInsets.only(
                                    right: 8, bottom: 8),
                                child: InkWell(onTap: () async{
                                  controller.text = e;
                                  await _controller.search(e);
                                },child: ItemSuggest(content: e))))
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
        ),
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
        ValueListenableBuilder<List<Generate>>(
          valueListenable: _controllerHome.generates,
          builder: (context, value, child) =>
              Wrap(
                children: [
                  ..._controllerHome.generates.value.map((e) =>
                      Container(
                          margin: const EdgeInsets.only(right: 8, bottom: 8),
                          child: InkWell(
                            child: ItemSuggest(content: e.name ?? ""),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListMangaGeners(
                                          title: e.name ?? "",
                                          generate: e,
                                        )),
                              );
                            },
                          )))
                ],
              ),
        )
      ],
    );
  }
}
