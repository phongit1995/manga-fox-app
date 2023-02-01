import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/app_config/theme/theme_data.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class UserPage extends StatefulWidget {

  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Container(
      height: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff4B526C), Color(0xff7BA8D2)]),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Asakura Yoh",
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Join from December 2022",
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: 220,
              width: double.maxFinite,
              child: Stack(
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(top: 43),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appColor.backgroundWhite,
                    ),
                    padding:
                        const EdgeInsets.only(top: 32, left: 16, right: 16),
                    child: Column(
                      children: [
                        Text(
                          "Buy Premium Member",
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 12,
                              color: appColor.primaryBlack,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No ads",
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 12,
                              color: appColor.primaryBlack,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Landscape reading mode",
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 12,
                              color: appColor.primaryBlack,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Download more chapter",
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 12,
                              color: appColor.primaryBlack,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                elevation: 0,
                                backgroundColor: Colors.transparent),
                            child: Container(
                              width: 161,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xffFF734A),
                                  Color(0xffFFA14A)
                                ]),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "Buy now",
                                style: AppStyle.mainStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 18),
                    child: SvgPicture.asset(AppImage.icDiamond),
                  )
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(top: 43),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: appColor.backgroundWhite,
              ),
              padding: const EdgeInsets.only(
                  top: 20, left: 16, right: 16, bottom: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppImage.icDarkMode),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Dark Mode",
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 12,
                              color: appColor.primaryBlack,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Spacer(),
                      ValueListenableBuilder<ThemeData>(
                        valueListenable: AppThemData().themeData,
                        builder: (context, value, child) {
                          return Switch(
                            value: value == AppThemData.dark,
                            thumbColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                return Colors.white;
                              },
                            ),
                            onChanged: (bool value) {
                              isDarkMode.value = value;
                              AppThemData().themeData.value = isDarkMode.value
                                  ? AppThemData.dark
                                  : AppThemData.light;
                            },
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
