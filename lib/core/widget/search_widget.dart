import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/ui/search/search_page.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool? isOnlyTap;

  const SearchWidget({Key? key, this.controller, this.isOnlyTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      enabled: isOnlyTap != true,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: "Search your manga, author...",
        contentPadding: EdgeInsets.zero,
        hintStyle: AppStyle.mainStyle.copyWith(
            color: const Color(0xff838383),
            fontSize: 12,
            fontWeight: FontWeight.w300),
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 16, right: 7),
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(AppImage.icSearch),
        ),
        prefixIconColor: const Color(0xff838383),
        suffix: ValueListenableBuilder(valueListenable: controller ?? TextEditingController(), builder: (context, value, child) {
          return InkWell(
            onTap: () {
              controller?.clear();
            },
            child: Container(
              padding: const EdgeInsets.only(right: 14),
              child: controller?.text.isEmpty == true
                  ? const SizedBox()
                  : SvgPicture.asset(AppImage.icCLose),
            ),
          );
        },),
      ),
    );
  }
}
