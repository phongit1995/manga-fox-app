import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/utils/handler_action.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/api_service_novel.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/novel_chapter.dart';
import 'package:manga_fox_app/ui/novel/reader/bottom_sheet_setting_reader_novel.dart';

class NovelReader extends StatefulWidget {
  final NovelChapter chapter;
  final List<NovelChapter> chapters;

  const NovelReader({
    Key? key,
    required this.chapter,
    required this.chapters,
  }) : super(key: key);

  @override
  State<NovelReader> createState() => _NovelReaderState();

  static Future transferNovelReader(
      BuildContext context, NovelChapter chapter, List<NovelChapter> chapters,
      {bool toDownload = false}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NovelReader(
                chapter: chapter,
                chapters: chapters,
              )),
    );
  }

  static Future transferReplace(BuildContext context, NovelChapter chapter,
      List<NovelChapter> chapters) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => NovelReader(
                chapter: chapter,
                chapters: chapters,
              )),
    );
  }
}

class _NovelReaderState extends State<NovelReader>
    with TickerProviderStateMixin {
  var indexPage = 0;
  var isHorizontal = true;
  final settingUtils = SettingUtils();
  ValueNotifier<bool> isShowInfo = ValueNotifier<bool>(false);
  final ScrollController _scrollController = ScrollController();
  late PageController _controller;
  late NovelChapter _chapter;
  late List<NovelChapter> _chapters;
  bool isLast = false;

  NovelChapter? nextChapter() {
    var i = _chapters.indexWhere((element) => element.sId == _chapter.sId);
    return i >= 0 && i < _chapters.length ? _chapters[i + 1] : null;
  }

  NovelChapter? backChapter() {
    var i = _chapters.indexWhere((element) => element.sId == _chapter.sId);
    return i > 0 ? _chapters[i - 1] : null;
  }

  final fonSize = ValueNotifier<double>(13);

  Future getFontSize() async {
    fonSize.value = (await settingUtils.getFontSizeNovel());
  }

  @override
  void initState() {
    super.initState();
    _chapters = widget.chapters;
    // _chapters.sort(
    //   (a, b) {
    //     if ((a.index ?? 0) > (b.index ?? 0)) {
    //       return 1;
    //     } else {
    //       return 0;
    //     }
    //   },
    // );
    updateChap(widget.chapter);
    _controller = PageController();
    getFontSize();
    // _scrollController.addListener(() {
    //   double maxScroll = _scrollController.position.maxScrollExtent;
    //   double currentScroll = _scrollController.position.pixels;
    //   double delta = 150;
    //   if (maxScroll - currentScroll <= delta) {
    //     isLast = true;
    //     isShowInfo.value = true;
    //   } else {
    //     isLast = false;
    //   }
    // });
  }

  void updateChap(NovelChapter c) {
    _chapter = c;
    HandlerAction().handlerAction(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    isShowInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).extension<AppColor>()!;
    return Scaffold(
      backgroundColor: appColor.backgroundWhite,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 2;
          if (details.delta.dy > sensitivity) {
            isShowInfo.value = true;
          } else if (details.delta.dy < -sensitivity && !isLast) {
            isShowInfo.value = false;
          }
        },
        child: _buildNetwork(),
      ),
    );
  }

  _buildNetwork() {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    if (_chapter.content?.isNotEmpty != true) {
      ApiServiceNovel.detailChapter(_chapter.sId ?? "").then(
        (value) {
          if (value != null) {
            setState(() {
              _chapter = value;
            });
          }
        },
      );
    }
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: NotificationListener<UserScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.direction == ScrollDirection.reverse) {
                    isShowInfo.value = false;
                  } else if (scrollNotification.direction ==
                      ScrollDirection.forward) {
                    isShowInfo.value = true;
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: ValueListenableBuilder<double>(
                      valueListenable: fonSize,
                      builder: (context, value, child) => HtmlWidget(
                        _chapter.content ?? '',
                        textStyle: AppStyle.mainStyle.copyWith(
                            color: appColor.primaryBlack,
                            fontSize: value,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              )),
          ValueListenableBuilder<bool>(
              valueListenable: isShowInfo,
              builder: (context, value, child) => Visibility(
                    visible: value,
                    child: Container(
                      color: appColor.primaryBackground,
                      padding: const EdgeInsets.only(
                          bottom: 22, top: 22, left: 20, right: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset(AppImage.icBackWhite,
                                color: appColor.primaryBlack),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Text(
                            _chapter.title ?? "",
                            style: AppStyle.mainStyle.copyWith(
                                color: appColor.primaryBlack3,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          )),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: appColor.backgroundWhite2,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return const BottomSheetSettingReaderNovel();
                                },
                              );
                              getFontSize();
                            },
                            child: SvgPicture.asset(AppImage.icSetting,
                                color: appColor.primaryBlack),
                          ),
                        ],
                      ),
                    ),
                  )),
          ValueListenableBuilder<bool>(
            valueListenable: isShowInfo,
            builder: (context, value, child) => Visibility(
              visible: value,
              child: Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    color: appColor.primaryBackground,
                    height: 70,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: backChapter() != null ? 1 : 0,
                          child: InkWell(
                              onTap: () {
                                var chapter = backChapter();
                                if (chapter != null) {
                                  NovelReader.transferReplace(
                                      context, chapter, _chapters);
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.keyboard_arrow_left_outlined,
                                      color: appColor.primaryBlack, size: 30),
                                  Text(
                                    'Back   ',
                                    style: AppStyle.mainStyle.copyWith(
                                        color: appColor.primaryBlack,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(width: 40),
                        Text(
                          '',
                          style: AppStyle.mainStyle.copyWith(
                              color: appColor.primaryBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        const SizedBox(width: 40),
                        Opacity(
                          opacity: nextChapter() == null ? 0 : 1,
                          child: InkWell(
                              onTap: () {
                                var chapter = nextChapter();
                                if (chapter != null) {
                                  NovelReader.transferReplace(
                                      context, chapter, _chapters);
                                }

                                // setState(() {
                                //   if (_indexChapter < _chapters.length - 1) {
                                //     _indexChapter++;
                                //     updateChap(_chapters[_indexChapter]);
                                //   }
                                // });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Next   ',
                                    style: AppStyle.mainStyle.copyWith(
                                        color: appColor.primaryBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                  Icon(Icons.keyboard_arrow_right_outlined,
                                      color: appColor.primaryBlack, size: 30),
                                ],
                              )),
                        ),
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
