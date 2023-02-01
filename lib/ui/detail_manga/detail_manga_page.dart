import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/chapter_mock.dart';
import 'package:manga_fox_app/ui/detail_manga/widget/item_chapter.dart';
import 'package:manga_fox_app/ui/manga_reader/manga_reader_page.dart';

class DetailMangaPage extends StatelessWidget {
  DetailMangaPage({Key? key}) : super(key: key);
  final ratingController = TextEditingController();

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
                        child: SvgPicture.asset(AppImage.icBack),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(AppImage.icSetting),
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
                          "https://st.ntcdntempv3.com/data/comics/126/the-gamer.jpg",
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
                              "Sound Asleep: Forgotten Memories",
                              style: AppStyle.mainStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: appColor.primaryBlack),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Basementraccoon",
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
                                      text: 'Continue',
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
                                      text: '123.456',
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
                                  initialRating: 4,
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
                                    text: '4.0',
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                    """The "calm" before the "storm".
A series of short stories centered on the lives of five girls before their world changed for the worse.
A 8-part side story to the parent story. "Sound Asleep".""",
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
                      SvgPicture.asset(AppImage.icFilter),
                      const SizedBox(width: 12),
                      SvgPicture.asset(AppImage.icList),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...mockChapter.map((e) => Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MangaReader()),
                              );
                            },
                            child: ItemChapter(
                                isRead: e.isRead,
                                content: e.title,
                                isDownload: e.isDownload),
                          ),
                          Divider(color: appColor.primaryDivider),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
