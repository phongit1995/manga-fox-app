import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_fox_app/app_config.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/app_setting.dart';
import 'package:manga_fox_app/core/utils/download_utils.dart';
import 'package:manga_fox_app/core/utils/handler_action.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/core/widget/app_dialog.dart';
import 'package:manga_fox_app/core/widget/progress_bar.dart';
import 'package:manga_fox_app/core/widget/shimmer_loading.dart';
import 'package:manga_fox_app/data/api_service.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/dao/chapter_dao.dart';
import 'package:manga_fox_app/data/dao/download_dao.dart';
import 'package:manga_fox_app/data/dao/manga_dao.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/bottom_sheet_report.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_controller.dart';
import 'package:manga_fox_app/ui/manga_reader/manga_reader_page.dart';
import 'package:manga_fox_app/ui/novel/detail/widget/item_chapter.dart';
import 'package:manga_fox_app/ui/user/in_app_page.dart';
import 'package:share_plus/share_plus.dart';

class DetailMangaPage extends StatefulWidget {
  final Manga manga;
  final bool? toHistory;
  final bool? toDownload;

  const DetailMangaPage(
      {Key? key, required this.manga, this.toHistory, this.toDownload})
      : super(key: key);

  @override
  State<DetailMangaPage> createState() => _DetailMangaPageState();

  static Future transfer(BuildContext context,
      {required Manga manga, bool? toHistory, bool? toDownload}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailMangaPage(
                manga: manga,
                toDownload: toDownload,
                toHistory: toHistory,
              )),
    );
  }
}

class _DetailMangaPageState extends State<DetailMangaPage> {
  final ratingController = TextEditingController();
  final _controller = DetailMangaController();
  final readMore = ValueNotifier<bool>(false);
  final viewGrid = ValueNotifier<bool>(false);
  final loading = ValueNotifier<bool>(true);
  final HandlerAction appAction = HandlerAction();
  final countDown = SettingUtils().getDownloadCountForDateNow();

  @override
  void initState() {
    super.initState();
    if (widget.toHistory != true) {
      MangaDAO().addMangaHistory(widget.manga);
    }
    loadData();
  }

  Future loadData() async {
    loading.value = true;
    await _controller.loadChapterLocal(widget.manga.sId ?? "");
    if (widget.toDownload != true) {
      await _controller.loadChapter(widget.manga.sId ?? "");
    }
    loading.value = false;
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 13),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset(
                        AppImage.icBack,
                        color: appColor.primaryBlack2,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
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
                              return const BottomSheetReport();
                            });
                      },
                      child: SvgPicture.asset(
                        AppImage.icWarring,
                        color: appColor.primaryBlack2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<bool>(
                  builder: (context, value, child) =>
                      _buildContent(isLoading: value),
                  valueListenable: loading,
                )
              ],
            ),
          )),
        ));
  }

  _buildGrid(List<ListChapter> chapters) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisExtent: 30,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4),
      itemCount: chapters.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        var chapter = chapters[index];
        return InkWell(
          onTap: () async {
            await _controller.cacheChapter(
                widget.manga.sId ?? "", chapter.sId ?? "");
            ChapterDAO().addReading(chapter.sId ?? "", widget.manga.sId ?? "");
            await transferMangaReader(chapter, chapters);
            setState(() {});
          },
          child: _buildItemGrid(
              chapter.index.toString(),
              (ChapterDAO().getReading(widget.manga.sId ?? "") ?? "") ==
                      (chapter.sId ?? "")
                  ? 3
                  : _controller.chapterCache.value.contains(chapter.sId ?? "")
                      ? 2
                      : 1),
        );
      },
    );
  }

  Future transferMangaReader(
      ListChapter chapter, List<ListChapter> chapters) async {
    appAction.handlerAction(() {
      MangaReader.transferMangaReader(context, chapter, chapters,
          toDownload: widget.toDownload ?? false);
    });
  }

  Widget _buildContent({required bool isLoading}) {
    AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: widget.manga.image ?? "",
                width: 162,
                height: 212,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.manga.name ?? "",
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: appColor.primaryBlack),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.manga.author ?? "",
                    maxLines: 1,
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: appColor.primaryBlack),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: 'STATUS: ',
                      style: AppStyle.mainStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: appColor.primaryBlack),
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.manga.mapStatus(),
                            style: AppStyle.mainStyle.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: appColor.primaryBlack))
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      text: 'Language: '.toUpperCase(),
                      style: AppStyle.mainStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: appColor.primaryBlack),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'English'.toUpperCase(),
                            style: AppStyle.mainStyle.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: appColor.primaryBlack))
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      text: 'Views: ',
                      style: AppStyle.mainStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: appColor.primaryBlack),
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.manga.mapView(),
                            style: AppStyle.mainStyle.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: appColor.primaryBlack))
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBar(
                        initialRating:
                            widget.manga.startRate?.toDouble() ?? 4.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 12,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.only(right: 3),
                        ratingWidget: RatingWidget(
                          full: SvgPicture.asset(AppImage.icStarYellow),
                          half: Icon(
                            Icons.star_half,
                            color: appColor.yellow,
                          ),
                          empty: Icon(
                            Icons.star_border,
                            color: appColor.yellow,
                          ),
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(width: 4),
                      RichText(
                        text: TextSpan(
                          text: widget.manga.mapRate(),
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: appColor.yellow),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.toDownload == true) {
                    var url = Platform.isAndroid
                        ? AppConfig.urlStoreAndroid
                        : AppConfig.urlStoreIos;
                    Share.share('Download and reading manga on $url');
                  } else {
                    MangaDAO().addMangaFavorite(widget.manga);
                    await FirebaseMessaging.instance
                        .subscribeToTopic(widget.manga.sId ?? "");
                  }
                  //     .unsubscribeFromTopic('myTopic');
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.centerRight),
                child: Container(
                  height: 43,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xffFF734A)),
                      color: Colors.transparent),
                  child: Text(
                    widget.toDownload == true ? "SHARE" : "FAVORITE",
                    style: AppStyle.mainStyle.copyWith(
                        color: const Color(0xffFF734A),
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ValueListenableBuilder(
              valueListenable: _controller.chapter,
              builder: (context, _, child) => Expanded(
                flex: 1,
                child: Opacity(
                  opacity: _controller.chapter.value.isNotEmpty ? 1 : 0,
                  child: ElevatedButton(
                    onPressed: () async {
                      var chapterId =
                          ChapterDAO().getReading(widget.manga.sId ?? "") ??
                              widget.manga.firstChapter?.sId ??
                              "";
                      if (chapterId.isNotEmpty &&
                          _controller.chapter.value.isNotEmpty) {
                        var e = _controller.chapter.value.firstWhere(
                            (element) => element.sId == chapterId,
                            orElse: () => ListChapter());
                        if (e.sId == null) return;
                        await transferMangaReader(e, _controller.chapter.value);
                        setState(() {});
                      }
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        alignment: Alignment.centerRight),
                    child: ValueListenableBuilder(
                      valueListenable:
                          Hive.box(ChapterDAO().chapterReadingDao).listenable(),
                      builder: (context, Box<dynamic> box, child) {
                        ListChapter? c;
                        var chapterId =
                            ChapterDAO().getReading(widget.manga.sId ?? "") ??
                                widget.manga.firstChapter?.sId ??
                                "";
                        if (chapterId.isNotEmpty) {
                          var e = _controller.chapter.value.firstWhere(
                              (element) => element.sId == chapterId,
                              orElse: () => ListChapter());
                          c = e.sId == null ? null : e;
                        }
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xffFF734A)),
                            alignment: Alignment.center,
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: FittedBox(
                              child: c == null
                                  ? Text(
                                      "Read Now".toUpperCase(),
                                      style: AppStyle.mainStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "CONTINUE ${c.name ?? ''}",
                                      style: AppStyle.mainStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text("What is about?",
            style: AppStyle.mainStyle.copyWith(
                color: appColor.primaryBlack,
                fontWeight: FontWeight.w500,
                fontSize: 15)),
        const SizedBox(height: 10),
        ValueListenableBuilder(
          valueListenable: readMore,
          builder: (context, value, child) => Column(
            children: [
              Text(
                widget.manga.description?.trim() ?? "",
                maxLines: !readMore.value ? 4 : null,
                style: AppStyle.mainStyle.copyWith(
                    color: appColor.primaryBlack,
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: true,
                child: InkWell(
                  onTap: () => readMore.value = !readMore.value,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          readMore.value ? "More less" : "Read More",
                          maxLines: readMore.value ? 3 : null,
                          style: AppStyle.mainStyle.copyWith(
                              color: appColor.primaryBlack,
                              fontWeight: FontWeight.w200,
                              fontSize: 10),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                            readMore.value
                                ? Icons.arrow_drop_up_sharp
                                : Icons.arrow_drop_down_sharp,
                            color: appColor.primaryBlack.withOpacity(0.6))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 19),
        if (!isLoading)
          widget.toDownload == true
              ? Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Downloaded Chapters",
                    style: AppStyle.mainStyle.copyWith(
                        color: appColor.primaryBlack3,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                )
              : Row(
                  children: [
                    Text("Chapters",
                        style: AppStyle.mainStyle.copyWith(
                            color: appColor.primaryBlack3,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    const Spacer(),
                    // InkWell(
                    //   child: SvgPicture.asset(AppImage.icFilter,
                    //       color: appColor.primaryBlack),
                    //   onTap: () {
                    //     _controller.revert = !_controller.revert;
                    //     setState(() {});
                    //   },
                    // ),
                    // const SizedBox(width: 12),
                    // InkWell(
                    //   onTap: () {
                    //     viewGrid.value = !viewGrid.value;
                    //   },
                    //   child: SvgPicture.asset(AppImage.icList,
                    //       color: appColor.primaryBlack),
                    // ),
                  ],
                ),
        const SizedBox(height: 10),
        Row(
          children: [
            InkWell(
              onTap: () {
                if (_controller.revert) {
                  _controller.revert = !_controller.revert;
                  setState(() {});
                }
              },
              child: Text("LATEST",
                  style: AppStyle.mainStyle.copyWith(
                      color: _controller.revert
                          ? appColor.primaryBlack3
                          : appColor.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 11)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Text("|",
                  style: AppStyle.mainStyle.copyWith(
                      color: appColor.primaryBlack3,
                      fontWeight: FontWeight.w500,
                      fontSize: 11)),
            ),
            InkWell(
              onTap: () {
                if (!_controller.revert) {
                  _controller.revert = !_controller.revert;
                  setState(() {});
                }
              },
              child: Text("OLDEST",
                  style: AppStyle.mainStyle.copyWith(
                      color: !_controller.revert
                          ? appColor.primaryBlack3
                          : appColor.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 11)),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                viewGrid.value = !viewGrid.value;
              },
              child: SvgPicture.asset(AppImage.icList,
                  color: appColor.primaryBlack),
            ),
          ],
        ),
        const SizedBox(height: 10),
        isLoading
            ? ShimmerLoading(isLoading: isLoading, child: _buildLoading())
            : ValueListenableBuilder(
                valueListenable: Hive.box("downloadImage").listenable(),
                builder: (context, Box<dynamic> box, child) {
                  return ValueListenableBuilder<List<ListChapter>>(
                    valueListenable: _controller.chapter,
                    builder: (context, c, child) {
                      List<ListChapter> chapter = [];
                      if (widget.toDownload == true && c.isNotEmpty) {
                        chapter = c
                            .where((element) =>
                                (box.get(element.sId ?? "")?.cast<String>() ??
                                        [])
                                    .isNotEmpty)
                            .toList();
                        if (chapter.isEmpty) {
                          MangaDAO().deleteMangaDownload(widget.manga);
                        }
                      } else {
                        chapter = c;
                      }

                      chapter.sort(
                          (a, b) => (a.index ?? 0).compareTo(b.index ?? 0));
                      if (_controller.revert) {
                        chapter = chapter.reversed.toList();
                      }
                      return ValueListenableBuilder<bool>(
                        valueListenable: viewGrid,
                        builder: (context, value, child) {
                          if (value) {
                            return _buildGrid(chapter);
                          } else {
                            return Column(children: [
                              ...chapter.map((e) {
                                List<String> data =
                                    box.get(e.sId ?? "")?.cast<String>() ?? [];
                                return Visibility(
                                  visible: !(widget.toDownload == true &&
                                      data.isEmpty),
                                  child: Column(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            await _controller.cacheChapter(
                                                widget.manga.sId ?? "",
                                                e.sId ?? "");
                                            ChapterDAO().addReading(e.sId ?? "",
                                                widget.manga.sId ?? "");
                                            await transferMangaReader(
                                                e, chapter);
                                            setState(() {});
                                          },
                                          child: ItemChapter(
                                              isRead: e.isRead == true,
                                              isLoading: DownloadUtils.task
                                                  .contains(e.sId ?? ""),
                                              chapter: e,
                                              onDownload: () async {
                                                var count = await SettingUtils()
                                                    .getDownloadCountForDateNow();
                                                if (count >=
                                                        AppConfig
                                                            .limitDownload &&
                                                    !AppSettingData()
                                                        .userPremium
                                                        .value) {
                                                  showDialogLimitDownload();
                                                  return;
                                                }
                                                if (data.isEmpty) {
                                                  DownloadUtils.task
                                                      .add(e.sId ?? "");
                                                  SettingUtils()
                                                      .setDownloadCountForDateNow(
                                                          "${count + 1}");
                                                  setState(() {});
                                                  final dataChapter =
                                                      await ApiService
                                                          .detailChapter(
                                                              e.sId!);
                                                  var url =
                                                      dataChapter!.images ?? [];
                                                  List<String> paths = [];
                                                  for (var u in url) {
                                                    try {
                                                      final path =
                                                          await DownloadUtils
                                                              .downloadImage(u);
                                                      paths.add(path ?? "");
                                                    } catch (error) {}
                                                  }
                                                  if (paths.isNotEmpty) {
                                                    DownloadDAO().add(
                                                        paths, e.sId ?? "");
                                                    MangaDAO().addMangaDownload(
                                                        widget.manga);
                                                  }
                                                  DownloadUtils.task
                                                      .remove(e.sId ?? "");
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          backgroundColor: appColor
                                                              .backgroundWhite2,
                                                          content: AppDialog()
                                                              .buildDialogDelete(
                                                            context,
                                                            e.name ?? "",
                                                            no: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            yes: () async {
                                                              await DownloadDAO()
                                                                  .delete(
                                                                      e.sId ??
                                                                          "");
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ));
                                                    },
                                                  );
                                                }
                                              },
                                              isDownload: data.isNotEmpty)),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 7, top: 7),
                                        child: ValueListenableBuilder(
                                            valueListenable: Hive.box(ChapterDAO()
                                                    .chapterPercentReadingDao)
                                                .listenable(),
                                            builder: (context, Box<dynamic> box,
                                                child) {
                                              return (box.get(e.sId ?? '',
                                                                  defaultValue:
                                                                      0.0)
                                                              as double? ??
                                                          0) ==
                                                      0
                                                  ? Divider(
                                                      color: appColor
                                                          .primaryDivider,
                                                      thickness: 1,
                                                      height: 1)
                                                  : AppProgress(
                                                      percent: box.get(
                                                                  e.sId ?? '',
                                                                  defaultValue:
                                                                      0.0)
                                                              as double? ??
                                                          0);
                                            }),
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ]);
                          }
                        },
                      );
                    },
                  );
                },
              )
      ],
    );
  }

  Future showDialogLimitDownload() async {
    AppColor appColor = Theme.of(context).extension<AppColor>()!;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: appColor.backgroundWhite2,
            content: AppDialog.buildDialog(
              context,
              "Limit download today.Become a vip to download unlimited stories and many other attractive features",
              no: () {
                Navigator.of(context).pop();
              },
              yes: () async {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const InAppPage()));
              },
            ));
      },
    );
  }

  Widget _buildItemGrid(String content, int type) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    if (type == 1) {
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: appColor.primaryBlack2)),
          alignment: Alignment.center,
          width: 45,
          height: 30,
          child: Text(
            content,
            style: AppStyle.mainStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: appColor.primaryBlack2),
            textAlign: TextAlign.center,
          ));
    } else if (type == 2) {
      return Container(
        alignment: Alignment.center,
        width: 45,
        height: 30,
        decoration: BoxDecoration(
            color: appColor.backgroundTabBar,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          content,
          style: AppStyle.mainStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: appColor.primaryBlack2),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: 45,
        height: 30,
        decoration: BoxDecoration(
            color: const Color(0xffFF734A),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          content,
          style: AppStyle.mainStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: appColor.backgroundWhite2),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.black,
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              width: 200,
              height: 40),
          itemCount: 10,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
        )
      ],
    );
  }
}
