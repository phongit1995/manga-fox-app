import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/utils/download_utils.dart';
import 'package:manga_fox_app/core/widget/app_dialog.dart';
import 'package:manga_fox_app/core/widget/shimmer_loading.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/dao/chapter_dao.dart';
import 'package:manga_fox_app/data/dao/download_dao.dart';
import 'package:manga_fox_app/data/dao/manga_dao.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_controller.dart';
import 'package:manga_fox_app/ui/detail_manga/widget/item_chapter.dart';
import 'package:manga_fox_app/ui/manga_reader/manga_reader_page.dart';

class DetailMangaPage extends StatefulWidget {
  final Manga manga;
  final bool? toHistory;
  final bool? toDownload;

  const DetailMangaPage(
      {Key? key, required this.manga, this.toHistory, this.toDownload})
      : super(key: key);

  @override
  State<DetailMangaPage> createState() => _DetailMangaPageState();
}

class _DetailMangaPageState extends State<DetailMangaPage> {
  final ratingController = TextEditingController();
  final _controller = DetailMangaController();
  final readMore = ValueNotifier<bool>(false);
  final viewGrid = ValueNotifier<bool>(false);
  final loading = ValueNotifier<bool>(true);

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
    await _controller.loadChapter(widget.manga.sId ?? "");
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
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppImage.icSetting,
                        color: appColor.primaryBlack2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<bool>(
                  builder: (context, value, child) =>
                      value ? ShimmerLoading(isLoading: value,child: _buildLoading(),) : _buildContent(),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MangaReader(
                        chapter: chapter,
                        chapters: chapters,
                      )),
            );
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

  Widget _buildContent() {
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
                width: 142,
                height: 178,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.manga.name ?? "",
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: appColor.primaryBlack),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.manga.author ?? "",
                    maxLines: 1,
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: appColor.primaryBlack),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: 'Status: ',
                      style: AppStyle.mainStyle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
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
                      text: 'Language: ',
                      style: AppStyle.mainStyle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: appColor.primaryBlack),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'English',
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
                      text: 'Views: ',
                      style: AppStyle.mainStyle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: appColor.primaryBlack),
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.manga.mapView(),
                            style: AppStyle.mainStyle.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: appColor.primaryBlack))
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBar(
                        initialRating:
                            (widget.manga.chapterUpdateCount ?? 0).toDouble(),
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 8,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: appColor.primaryBlack,
                          ),
                          half: Icon(
                            Icons.star_half,
                            color: appColor.primaryBlack,
                          ),
                          empty: Icon(
                            Icons.star_border,
                            color: appColor.primaryBlack,
                          ),
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(width: 4),
                      RichText(
                        text: TextSpan(
                          text: widget.manga.chapterUpdateCount.toString(),
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: appColor.primaryBlack),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _controller.chapter,
                        builder: (context, _, child) => Opacity(
                          opacity: _controller.chapter.value.isNotEmpty ? 1 : 0,
                          child: ElevatedButton(
                              onPressed: () {
                                var chapterId = ChapterDAO()
                                        .getReading(widget.manga.sId ?? "") ??
                                    widget.manga.firstChapter?.sId ??
                                    "";
                                if (chapterId.isNotEmpty &&
                                    _controller.chapter.value.isNotEmpty) {
                                  var e = _controller.chapter.value.firstWhere(
                                      (element) => element.sId == chapterId,
                                      orElse: () => ListChapter());
                                  if (e.sId == null) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MangaReader(
                                              chapter: e,
                                              chapters:
                                                  _controller.chapter.value,
                                            )),
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  alignment: Alignment.centerRight),
                              child: Container(
                                width: 94,
                                height: 37,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffFF734A)),
                                child: Text(
                                  "Read Now",
                                  style: AppStyle.mainStyle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 10),
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                          onPressed: () async {
                            MangaDAO().addMangaFavorite(widget.manga);
                            print(widget.manga.sId ?? "");
                            await FirebaseMessaging.instance
                                .subscribeToTopic(widget.manga.sId ?? "");
                            //     .unsubscribeFromTopic('myTopic');
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              alignment: Alignment.centerRight),
                          child: Container(
                            width: 75,
                            height: 37,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xffFF734A)),
                                color: Colors.transparent),
                            child: Text(
                              "Save",
                              style: AppStyle.mainStyle.copyWith(
                                  color: const Color(0xffFF734A),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Text("What is about?",
            style: AppStyle.mainStyle.copyWith(
                color: appColor.primaryBlack,
                fontWeight: FontWeight.w400,
                fontSize: 12)),
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
                    fontWeight: FontWeight.w300,
                    fontSize: 10),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: !readMore.value,
                child: InkWell(
                  onTap: () => readMore.value = true,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          "Read More",
                          maxLines: readMore.value ? 3 : null,
                          style: AppStyle.mainStyle.copyWith(
                              color: appColor.primaryBlack,
                              fontWeight: FontWeight.w200,
                              fontSize: 10),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down_sharp,
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
        widget.toDownload == true
            ? Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Downloaded Book",
                  style: AppStyle.mainStyle.copyWith(
                      color: appColor.primaryBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              )
            : Row(
                children: [
                  Text("Chapters",
                      style: AppStyle.mainStyle.copyWith(
                          color: appColor.primaryBlack,
                          fontWeight: FontWeight.w400,
                          fontSize: 14)),
                  const Spacer(),
                  InkWell(
                    child: SvgPicture.asset(AppImage.icFilter,
                        color: appColor.primaryBlack),
                    onTap: () {
                      _controller.revert = !_controller.revert;
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 12),
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
        ValueListenableBuilder(
          valueListenable: Hive.box("downloadImage").listenable(),
          builder: (context, Box<dynamic> box, child) {
            return ValueListenableBuilder<List<ListChapter>>(
              valueListenable: _controller.chapter,
              builder: (context, c, child) {
                List<ListChapter> chapter = [];
                if (widget.toDownload == true && c.isNotEmpty) {
                  chapter = c
                      .where((element) =>
                          (box.get(element.sId ?? "")?.cast<String>() ?? [])
                              .isNotEmpty)
                      .toList();
                } else {
                  chapter = c;
                }

                chapter.sort((a, b) => (a.index ?? 0).compareTo(b.index ?? 0));
                if (_controller.revert) {
                  chapter = chapter.reversed.toList();
                }
                return chapter.isEmpty
                    ? const SizedBox(
                        height: 50,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : ValueListenableBuilder<bool>(
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MangaReader(
                                                        chapter: e,
                                                        chapters: chapter,
                                                      )),
                                            );
                                            setState(() {});
                                          },
                                          child: ItemChapter(
                                              isRead: e.isRead == true,
                                              isLoading: DownloadUtils.task
                                                  .contains(e.sId ?? ""),
                                              chapter: e,
                                              onDownload: () async {
                                                if (data.isEmpty) {
                                                  DownloadUtils.task
                                                      .add(e.sId ?? "");
                                                  setState(() {});
                                                  var url = e.images ?? [];
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
                                                  setState(() {});
                                                } else {
                                                  showDialog(
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
                                                            yes: () {
                                                              DownloadDAO()
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
                                        child: Divider(
                                            color: appColor.primaryDivider,
                                            thickness: 1,
                                            height: 1),
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
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black,
              ),
              width: 142,
              height: 178,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      width: 200,
                      height: 14),
                  const SizedBox(height: 4),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      width: 20,
                      height: 10),
                  const SizedBox(height: 16),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      width: 60,
                      height: 10),
                  const SizedBox(height: 4),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      width: 20,
                      height: 10),
                  const SizedBox(height: 4),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      width: 70,
                      height: 10),
                  const SizedBox(height: 4),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      width: 50,
                      height: 10),
                  const SizedBox(height: 4),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      width: 100,
                      height: 40),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black,
            ),
            width: 1000,
            height: 100),
        const SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black,
            ),
            width: 100,
            height: 10),
        const SizedBox(height: 10),
        ListView.builder(
          itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black,
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 200,
              height: 20),
          itemCount: 10,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
        )
      ],
    );
  }
}
