import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/widget/shimmer_loading.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';

class BannerWidget extends StatefulWidget {
  final List<Manga> mangas;

  const BannerWidget({super.key, required this.mangas});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final CarouselController _controller = CarouselController();

  final indexPage = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).extension<AppColor>()!;
    if(widget.mangas.isEmpty) {
      return  ValueListenableBuilder<int>(
        valueListenable: indexPage,
        builder: (context, i, child) => Column(
          children: [
            CarouselSlider(
                carouselController: _controller,
                items: List.generate(5, (index) => ShimmerLoading(
                  isLoading: true,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      width: double.maxFinite,
                      height: 160),
                )),
                options: CarouselOptions(
                  height: 160,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  onPageChanged: (index, reason) {
                    indexPage.value = index;
                  },
                  scrollDirection: Axis.horizontal,
                )),
          ],
        ),
      );
    }
    return ValueListenableBuilder<int>(
      valueListenable: indexPage,
      builder: (context, i, child) => Column(
        children: [
          CarouselSlider(
              carouselController: _controller,
              items: [
                ...widget.mangas.map((m) => Stack(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          height: 160,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: m.image ?? '',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8)),
                            width: double.maxFinite,
                            height: 160),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              const Spacer(),
                              Text(m.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppStyle.mainStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "PlayfairDisplay",
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 4),
                              Text(m.author ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppStyle.mainStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 7,
                                      letterSpacing: 0.8,
                                      fontFamily: "PlayfairDisplay",
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 17),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
              options: CarouselOptions(
                height: 160,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                onPageChanged: (index, reason) {
                  indexPage.value = index;
                },
                scrollDirection: Axis.horizontal,
              )),
          const SizedBox(height: 12),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                  widget.mangas.length,
                  (index) => InkWell(
                    onTap: () {
                      _controller.animateToPage(index);
                    },
                    child: Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: i == index
                                  ? appColor.primary
                                  : appColor.indicatorBanner),
                        ),
                  )))
        ],
      ),
    );
  }
}
