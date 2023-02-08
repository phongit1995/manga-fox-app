import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/manga_mock.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';
import 'package:manga_fox_app/ui/manga_reader/bottom_sheet_setting_reader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MangaReader extends StatefulWidget {
  final ListChapter chapter;

  const MangaReader({Key? key, required this.chapter}) : super(key: key);

  @override
  State<MangaReader> createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader>
    with TickerProviderStateMixin {
  var indexPage = 0;
  var isHorizontal = true;
  final settingUtils = SettingUtils();
  ValueNotifier<bool> isShowInfo = ValueNotifier<bool>(true);
  final ScrollController _scrollController = ScrollController();
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    currentData();
    _controller = PageController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
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
          } else if (details.delta.dy < -sensitivity) {
            isShowInfo.value = false;
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              isHorizontal
                  ? PhotoViewGallery.builder(
                      pageController: _controller,
                      itemCount: (widget.chapter.images ?? []).length,
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (context, i) {
                        return PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(
                              (widget.chapter.images ?? [])[i],
                              headers: {"Referer": "https://manganelo.com/"},
                            ),
                            minScale: PhotoViewComputedScale.contained * 1,
                            maxScale: PhotoViewComputedScale.covered * 2.0,
                            initialScale:
                                PhotoViewComputedScale.contained * 1.0,
                            heroAttributes: PhotoViewHeroAttributes(
                                tag: (widget.chapter.images ?? [])[i]));
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
                            ScrollDirection.reverse) {
                          isShowInfo.value = false;
                        } else if (_scrollController
                                .position.userScrollDirection ==
                            ScrollDirection.forward) {
                          isShowInfo.value = true;
                        }
                        return true;
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            ...(widget.chapter.images ?? [])
                                .map((e) => Image.network(
                                      e,
                                      fit: BoxFit.fitWidth,
                                      width: double.maxFinite,
                                      headers: {
                                        "Referer": "https://manganelo.com/"
                                      },
                                    ))
                          ],
                        ),
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
                                widget.chapter.name ?? "",
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
                  visible: value && isHorizontal,
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
                              opacity: indexPage <= 0 ? 0 : 1,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (indexPage >= 0) {
                                        indexPage--;
                                        _controller.jumpToPage(indexPage);
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
                              '${indexPage + 1}/${(widget.chapter.images ?? []).length}',
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
                                  indexPage >= mangaMock.length - 1 ? 0 : 1,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (indexPage < mangaMock.length - 1) {
                                        indexPage++;
                                        _controller.jumpToPage(indexPage);
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
        ),
      ),
    );
  }
}
