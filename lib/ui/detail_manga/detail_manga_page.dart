import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_controller.dart';
import 'package:manga_fox_app/ui/detail_manga/widget/item_chapter.dart';
import 'package:manga_fox_app/ui/manga_reader/manga_reader_page.dart';

class DetailMangaPage extends StatefulWidget {
  final Manga manga;

  const DetailMangaPage({Key? key, required this.manga}) : super(key: key);

  @override
  State<DetailMangaPage> createState() => _DetailMangaPageState();
}

class _DetailMangaPageState extends State<DetailMangaPage> {
  final ratingController = TextEditingController();
  final _controller = DetailMangaController();

  @override
  void initState() {
    super.initState();
    _controller.loadChapter(widget.manga.sId ?? "");
    Logger().e(widget.manga.toJson());
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        widget.manga.image ?? "",
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
                                    (widget.manga.chapterUpdateCount ?? 0)
                                        .toDouble(),
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
                                  text: widget.manga.chapterUpdateCount
                                      .toString(),
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
                              ElevatedButton(
                                  onPressed: () {},
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
                              const SizedBox(width: 4),
                              ElevatedButton(
                                  onPressed: () {},
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
                                        border: Border.all(
                                            color: const Color(0xffFF734A)),
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
                Text(
                  widget.manga.description?.trim() ?? "",
                  style: AppStyle.mainStyle.copyWith(
                      color: appColor.primaryBlack,
                      fontWeight: FontWeight.w300,
                      fontSize: 10),
                ),
                const SizedBox(height: 19),
                Row(
                  children: [
                    Text("Chapters",
                        style: AppStyle.mainStyle.copyWith(
                            color: appColor.primaryBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 14)),
                    const Spacer(),
                    InkWell(
                      child: SvgPicture.asset(AppImage.icFilter),
                      onTap: () {
                        _controller.chapter.value =
                            _controller.chapter.value.reversed.toList();
                      },
                    ),
                    const SizedBox(width: 12),
                    SvgPicture.asset(AppImage.icList),
                  ],
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<List<ListChapter>>(
                  valueListenable: _controller.chapter,
                  builder: (context, chapter, child) => chapter.isEmpty
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
                      : Column(children: [
                          ...chapter.map((e) => Column(
                                children: [
                                  InkWell(
                                    onTap: () async{
                                      await _controller.cacheChapter(widget.manga.sId ?? "", e.sId ?? "");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MangaReader(chapter: e)),
                                      );
                                      setState(() {});
                                    },
                                    child: ItemChapter(
                                        isRead: e.isRead == true,
                                        content: e.name ?? "",
                                        isDownload: widget.manga.isDownload),
                                  ),
                                  Divider(color: appColor.primaryDivider),
                                ],
                              ))
                        ]),
                )
              ],
            ),
          )),
        ));
  }
}
