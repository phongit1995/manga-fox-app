import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/dao/chapter_dao.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';
import 'package:manga_fox_app/ui/manga_reader/bottom_sheet_setting_reader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MangaReader extends StatefulWidget {
  final ListChapter chapter;
  final List<ListChapter> chapters;

  const MangaReader({Key? key, required this.chapter, required this.chapters})
      : super(key: key);

  @override
  State<MangaReader> createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader>
    with TickerProviderStateMixin {
  var indexPage = 0;
  var _indexChapter = 0;
  var isHorizontal = true;
  final settingUtils = SettingUtils();
  ValueNotifier<bool> isShowInfo = ValueNotifier<bool>(false);
  final ScrollController _scrollController = ScrollController();
  late PageController _controller;
  late ListChapter _chapter;
  late List<ListChapter> _chapters;
  bool isLast = false;

  @override
  void initState() {
    super.initState();
    _chapters = widget.chapters;
    _chapters.sort(
      (a, b) {
        if ((a.index ?? 0) > (b.index ?? 0)) {
          return 1;
        } else {
          return 0;
        }
      },
    );
    updateChap(widget.chapter);
    currentData();
    _controller = PageController();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 150;
      if (maxScroll - currentScroll <= delta) {
        isLast = true;
        isShowInfo.value = true;
      } else {
        isLast = false;
      }
    });
  }

  void updateChap(ListChapter c) {
    _chapter = c;
    _indexChapter =
        _chapters.indexWhere((element) => element.sId == _chapter.sId);
  }

  @override
  void dispose() {
    if ((_chapter.images?.length ?? 1) - (indexPage + 1) <= 1) {
      ChapterDAO().addPercentChapterReading(widget.chapter.sId ?? "", 1);
    } else {
      ChapterDAO().addPercentChapterReading(widget.chapter.sId ?? "",
          (indexPage + 1) / (_chapter.images?.length ?? 1));
    }
    _scrollController.dispose();
    _controller.dispose();
    isShowInfo.dispose();
    super.dispose();
  }

  Future currentData() async {
    isHorizontal = (await settingUtils.horizontal);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 2;
          if (details.delta.dy > sensitivity) {
            isShowInfo.value = true;
          } else if (details.delta.dy < -sensitivity && !isLast) {
            isShowInfo.value = false;
          }
        },
        child: ValueListenableBuilder(
          valueListenable: Hive.box("downloadImage").listenable(),
          builder: (context, Box<dynamic> box, child) {
            List<String> data =
                box.get(_chapter.sId ?? "")?.cast<String>() ?? [];
            return data.isEmpty ? _buildNetwork() : _buildLocal(data);
          },
        ),
      ),
    );
  }

  _buildLocal(List<String> data) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            height: double.maxFinite,
            child: !isHorizontal
                ? PhotoViewGallery.builder(
                    pageController: _controller,
                    itemCount: data.length,
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (context, i) {
                      return PhotoViewGalleryPageOptions(
                          imageProvider: FileImage(File(data[i])),
                          minScale: PhotoViewComputedScale.contained * 1,
                          maxScale: PhotoViewComputedScale.covered * 2.0,
                          initialScale: PhotoViewComputedScale.contained * 1.0,
                          heroAttributes:
                              PhotoViewHeroAttributes(tag: data[i]));
                    },
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (int value) {
                      if (value < indexPage) {
                        isShowInfo.value = true;
                      } else {
                        isShowInfo.value = false;
                      }
                      setState(() {
                        indexPage = value;
                      });
                    },
                    loadingBuilder: (context, event) => const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (_scrollController.position.userScrollDirection ==
                          ScrollDirection.reverse && !isLast) {
                        isShowInfo.value = false;
                      } else if (_scrollController
                              .position.userScrollDirection ==
                          ScrollDirection.forward) {
                        isShowInfo.value = true;
                      }
                      return true;
                    },
                    child: InViewNotifierList(
                      isInViewPortCondition: (double deltaTop,
                          double deltaBottom, double vpHeight) {
                        return deltaTop < (0.5 * vpHeight) &&
                            deltaBottom > (0.5 * vpHeight);
                      },
                      itemCount: data.length,
                      controller: _scrollController,
                      shrinkWrap: true,
                      builder: (BuildContext context, int index) {
                        return InViewNotifierWidget(
                          id: '$index',
                          builder: (context, isInView, child) {
                            if (isInView) {
                              indexPage = index;
                            }
                            var e = data[index];
                            return Image.file(
                              File(e),
                              fit: BoxFit.fitWidth,
                              width: double.maxFinite,
                            );
                          },
                        );
                      },
                    )

                    // SingleChildScrollView(
                    //   controller: _scrollController,
                    //   child: Column(
                    //     children: [
                    //       ...data.map((e) => Image.file(
                    //             File(e),
                    //             fit: BoxFit.fitWidth,
                    //             width: double.maxFinite,
                    //           ))
                    //     ],
                    //   ),
                    // ),
                    ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: isShowInfo,
              builder: (context, value, child) => Visibility(
                    visible: value,
                    child: Container(
                      color: const Color(0xff333333),
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
                            child: SvgPicture.asset(AppImage.icBackWhite),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Text(
                            _chapter.name ?? "",
                            style: AppStyle.mainStyle.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
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
                                  return const BottomSheetSettingReader();
                                },
                              );
                              await currentData();
                            },
                            child: SvgPicture.asset(AppImage.icSetting),
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
                    color: const Color(0xff333333),
                    height: 70,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: _indexChapter <= 0 ? 0 : 1,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_indexChapter > 0) {
                                    _indexChapter--;
                                    updateChap(_chapters[_indexChapter]);
                                    // if(isHorizontal) {
                                    //   _controller.jumpToPage(0);
                                    // }
                                  }
                                });
                              },
                              child: const Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  color: Colors.white,
                                  size: 30)),
                        ),
                        const SizedBox(width: 40),
                        Text(
                          '${isLast ? _chapter.images?.length ?? 0 : (indexPage + 1)}/${_chapter.images?.length ?? 0}',
                          style: AppStyle.mainStyle.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        const SizedBox(width: 40),
                        Opacity(
                          opacity:
                              _indexChapter >= _chapters.length - 1 ? 0 : 1,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_indexChapter <= _chapters.length - 1) {
                                    _indexChapter++;
                                    updateChap(_chapters[_indexChapter]);
                                  }
                                });
                              },
                              child: const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.white,
                                  size: 30)),
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

  _buildNetwork() {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            height: double.maxFinite,
            child: !isHorizontal
                ? PhotoViewGallery.builder(
                    pageController: _controller,
                    itemCount: (_chapter.images ?? []).length,
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (context, i) {
                      return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(
                            (_chapter.images ?? [])[i],
                            headers: {"Referer": "https://manganelo.com/"},
                          ),
                          minScale: PhotoViewComputedScale.contained * 1,
                          maxScale: PhotoViewComputedScale.covered * 2.0,
                          initialScale: PhotoViewComputedScale.contained * 1.0,
                          heroAttributes: PhotoViewHeroAttributes(
                              tag: (_chapter.images ?? [])[i]));
                    },
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (int value) {
                      if (value < indexPage) {
                        isShowInfo.value = true;
                      } else {
                        isShowInfo.value = false;
                      }
                      setState(() {
                        indexPage = value;
                      });
                    },
                    loadingBuilder: (context, event) => const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (_scrollController.position.userScrollDirection ==
                          ScrollDirection.reverse && !isLast) {
                        isShowInfo.value = false;
                      } else if (_scrollController
                              .position.userScrollDirection ==
                          ScrollDirection.forward) {
                        isShowInfo.value = true;
                      }
                      return true;
                    },
                    child: InViewNotifierList(
                      isInViewPortCondition: (double deltaTop,
                          double deltaBottom, double vpHeight) {
                        return deltaTop < (0.5 * vpHeight) &&
                            deltaBottom > (0.5 * vpHeight);
                      },
                      itemCount: (_chapter.images ?? []).length,
                      controller: _scrollController,
                      shrinkWrap: true,
                      builder: (BuildContext context, int index) {
                        return InViewNotifierWidget(
                          id: '$index',
                          builder: (context, isInView, child) {
                            if (isInView) {
                              indexPage = index;
                            }
                            var e = (_chapter.images ?? [])[index];
                            return Image.network(
                              e,
                              fit: BoxFit.fitWidth,
                              width: double.maxFinite,
                              headers: {"Referer": "https://manganelo.com/"},
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 50),
                                    child: const CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 100),
                                    child: const Icon(
                                        Icons.image_not_supported_outlined),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    )

                    // SingleChildScrollView(
                    //   controller: _scrollController,
                    //   child: Column(
                    //     children: [
                    //       ...(_chapter.images ?? []).map((e) => Image.network(
                    //             e,
                    //             fit: BoxFit.fitWidth,
                    //             width: double.maxFinite,
                    //             headers: {"Referer": "https://manganelo.com/"},
                    //           ))
                    //     ],
                    //   ),
                    // ),
                    ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: isShowInfo,
              builder: (context, value, child) => Visibility(
                    visible: value,
                    child: Container(
                      color: const Color(0xff333333),
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
                            child: SvgPicture.asset(AppImage.icBackWhite),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Text(
                            _chapter.name ?? "",
                            style: AppStyle.mainStyle.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
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
                                  return const BottomSheetSettingReader();
                                },
                              );
                              await currentData();
                            },
                            child: SvgPicture.asset(AppImage.icSetting),
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
                    color: const Color(0xff333333),
                    height: 70,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: _indexChapter < 0 ? 0 : 1,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_indexChapter > 0) {
                                    _indexChapter--;
                                    updateChap(_chapters[_indexChapter]);
                                  }
                                });
                              },
                              child: const Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  color: Colors.white,
                                  size: 30)),
                        ),
                        const SizedBox(width: 40),
                        Text(
                          '${isLast ? _chapter.images?.length ?? 0 : (indexPage + 1)}/${_chapter.images?.length ?? 0}',
                          style: AppStyle.mainStyle.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        const SizedBox(width: 40),
                        Opacity(
                          opacity:
                              _indexChapter >= (_chapters.last.index ?? 0) - 1
                                  ? 0
                                  : 1,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_indexChapter < _chapters.length - 1) {
                                    _indexChapter++;
                                    updateChap(_chapters[_indexChapter]);
                                  }
                                });
                              },
                              child: const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.white,
                                  size: 30)),
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
