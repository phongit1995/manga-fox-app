import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class InAppPage extends StatelessWidget {
  const InAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff4B526C), Color(0xff7BA8D2)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    backgroundColor: Colors.transparent),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xffFF734A), Color(0xffFFA14A)]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Become VIP",
                    style: AppStyle.mainStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                )),
            SizedBox(height: 12),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Restore purchase",
                style: AppStyle.mainStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    fontSize: 14),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xffFF734A),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.close_outlined,
                        size: 24,
                        color: Colors.white,
                      )),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    "Become to VIP\nMember".toUpperCase(),
                    style: AppStyle.mainStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "When you pay the fee to become a vip\nmember, you will get the following benefits:",
                    style: AppStyle.mainStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  _buildCheck("Remove all ads in application"),
                  const SizedBox(height: 6),
                  _buildCheck("Landscape reading mode"),
                  const SizedBox(height: 6),
                  _buildCheck("Download more chapter"),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 33),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "1 Year",
                              style: AppStyle.mainStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "365 days read manga",
                              style: AppStyle.mainStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Text(
                          "899.000 đ",
                          style: AppStyle.mainStyle.copyWith(
                              color: const Color(0xffFF734A),
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 33),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "1 Month",
                              style: AppStyle.mainStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "30 days read manga",
                              style: AppStyle.mainStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Text(
                          "99.000 đ",
                          style: AppStyle.mainStyle.copyWith(
                              color: const Color(0xffFF734A),
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCheck(String content) {
    return Row(
      children: [
        const Icon(Icons.check, color: Color(0xffFF734A)),
        const SizedBox(width: 8),
        Text(
          content,
          style: AppStyle.mainStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ],
    );
  }
}
