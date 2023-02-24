import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/app_config/theme/theme_data.dart';
import 'package:manga_fox_app/core/utils/download_utils.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:manga_fox_app/data/dao/download_dao.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ValueNotifier<bool> isDarkMode = ValueNotifier(false);
  final ValueNotifier<bool> isShowNotification = ValueNotifier(false);

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
              alignment: Alignment.topCenter,
              child: Text(
                "Settings",
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    backgroundColor: Colors.transparent),
                child: Container(
                  width: double.maxFinite,
                  height: 48,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xffFF734A),
                      Color(0xffFFA14A)
                    ]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      SvgPicture.asset(AppImage.icDiamond),
                      const SizedBox(width: 16),
                      Text(
                        "Become to V.I.P Member",
                        style: AppStyle.mainStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ],
                  ),
                )),
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(top: 20),
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
                              SettingUtils().setDartMode(value);
                              AppThemData().themeData.value = isDarkMode.value
                                  ? AppThemData.dark
                                  : AppThemData.light;
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Divider(
                      color: appColor.primaryDivider, thickness: 1, height: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppImage.icNotification),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Notification",
                          style: AppStyle.mainStyle.copyWith(
                              fontSize: 12,
                              color: appColor.primaryBlack,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Spacer(),
                      ValueListenableBuilder<bool>(
                        valueListenable: isShowNotification,
                        builder: (context, value, child) {
                          return Switch(
                            value: value,
                            thumbColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                return Colors.white;
                              },
                            ),
                            onChanged: (bool value) {
                              isShowNotification.value = value;
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Divider(
                      color: appColor.primaryDivider, thickness: 1, height: 1),

                  const SizedBox(height: 18),
                  _buildItem(
                    "About Us",
                    AppImage.icStar,
                    onTap: () {},
                  ),
                  const SizedBox(height: 13),
                  Divider(
                      color: appColor.primaryDivider, thickness: 1, height: 1),
                  const SizedBox(height: 18),
                  _buildItem(
                    "Share App",
                    AppImage.icShare,
                    onTap: () {},
                  ),
                  const SizedBox(height: 13),
                  Divider(
                      color: appColor.primaryDivider, thickness: 1, height: 1),
                  const SizedBox(height: 18),
                  _buildItem(
                    "Rating",
                    AppImage.icRating,
                    onTap: () {},
                  ),
                  const SizedBox(height: 13),
                  Divider(
                      color: appColor.primaryDivider, thickness: 1, height: 1),
                  const SizedBox(height: 18),
                  _buildItem(
                    "Join - Facebook Support",
                    AppImage.icFB,
                    onTap: () {},
                  ),
                  const SizedBox(height: 13),
                  Divider(
                      color: appColor.primaryDivider, thickness: 1, height: 1),
                  const SizedBox(height: 18),
                  _buildItem(
                    "Term of Privacy",
                    AppImage.icTerm,
                    onTap: () {},
                  ),
                  const SizedBox(height: 13),
                  Divider(
                      color: appColor.primaryDivider, thickness: 1, height: 1),
                  const SizedBox(height: 18),
                  _buildItem(
                    "Clear Caches",
                    AppImage.icDeleteCache,
                    onTap: () {
                      DownloadUtils().deleteAppDir();
                      DownloadDAO().deleteAll();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String content, String iconPath,
      {required VoidCallback onTap, bool? switchTab}) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(iconPath),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: AppStyle.mainStyle.copyWith(
                  fontSize: 12,
                  color: appColor.primaryBlack,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
