import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/utils/handler_action.dart';
import 'package:manga_fox_app/core/widget/separator.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/dao/chapter_dao.dart';
import 'package:manga_fox_app/data/dao/manga_dao.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/detail_manga/detail_manga_page.dart';
import 'package:manga_fox_app/ui/library/bottom_sheet_setting_more_option.dart';

class LibraryDownload extends StatelessWidget {
  LibraryDownload({Key? key}) : super(key: key);
  final HandlerAction appAction = HandlerAction();

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Downloaded Book",
              style: AppStyle.mainStyle.copyWith(
                  color: appColor.primaryBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder(
              valueListenable: Hive.box(MangaDAO.manga).listenable(),
              builder: (context,Box<dynamic> box, child) {
                var data = box.get(MangaDAO.mangaDownload)?.cast<Manga>() ?? [];
                return Column(
                  children: [
                    ...data.map((e) {
                      return Column(
                        children: [
                          _buildItem(context, e),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 7, top: 7),
                            child: const Separator(),)
                        ],
                      );
                    })
                  ],
                );
              }
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, Manga manga) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return ValueListenableBuilder(
        valueListenable: Hive.box("downloadImage").listenable(),
    builder: (context, Box<dynamic> box, child) {
          var chapters = ChapterDAO().getListChapter(manga.sId ?? "");
          var download = chapters
              .where((element) =>
          (box.get(element.sId ?? "")?.cast<String>() ??
              [])
              .isNotEmpty)
              .toList();
      return Visibility(
        visible: download.isNotEmpty,
        child: InkWell(
          onTap: () {
            DetailMangaPage.transfer(context, manga: manga, toDownload: true);
          },
          child: Container(
            height: 80,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: manga.image ?? "",
                    width: 80,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        manga.name ?? "",
                        maxLines: 2,
                        style: AppStyle.mainStyle.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: appColor.primaryBlack),
                      ),
                      const SizedBox(height: 4),
                      RatingBar(
                        initialRating: manga.startRate?.toDouble() ?? 4.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 8,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.only(right: 6),
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
                      const SizedBox(height: 4),
                      Text(
                        "${download.length}/${chapters.length} Chapters Downloaded",
                        maxLines: 1,
                        style: AppStyle.mainStyle.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: appColor.primaryBlack),
                      ),
                    ],
                  ),
                ),
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
                         return BottomSheetSettingMoreOption(type: 2,read: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) =>
                                     DetailMangaPage(
                                       manga: manga, toDownload: true,)),
                           );
                         },remove: () {
                           MangaDAO().deleteMangaDownload(manga);
                           Navigator.of(
                               context)
                               .pop();
                         },share: () {
                           Navigator.of(
                               context)
                               .pop();
                         },);
                       },
                     );
                   },
                  child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: appColor.primaryBlack2,
                        size: 12,
                      )),
                ),
              ],
            ),
          ),
        ),
      );
    },
    );
  }

  Future loadChapterLocal(String idManga) async {
    var chapters = ChapterDAO().getListChapter(idManga);
  }
}
