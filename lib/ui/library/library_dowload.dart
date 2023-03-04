import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/utils/handler_action.dart';
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
                            margin: const EdgeInsets.only(left: 107, right: 20, bottom: 7, top: 7),
                            child: Divider(color: appColor.primaryDivider, thickness: 1, height: 1),
                          ),
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
                      const SizedBox(height: 8),
                      // Text(
                      //   "Adventure",
                      //   style: AppStyle.mainStyle.copyWith(
                      //       fontSize: 10,
                      //       fontWeight: FontWeight.w300,
                      //       color: appColor.primaryBlack),
                      // ),
                      const SizedBox(height: 4),
                      Text(
                        manga.name ?? "",
                        maxLines: 2,
                        style: AppStyle.mainStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: appColor.primaryBlack),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${download.length}/${chapters.length} Chapters Downloaded",
                        maxLines: 1,
                        style: AppStyle.mainStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFF734A)),
                      ),
                      const SizedBox(height: 4),
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
