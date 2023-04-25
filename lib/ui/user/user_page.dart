import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_reader_app/app_config.dart';
import 'package:manga_reader_app/core/app_config/app_image.dart';
import 'package:manga_reader_app/core/app_config/app_style.dart';
import 'package:manga_reader_app/core/app_config/theme/theme_data.dart';
import 'package:manga_reader_app/core/app_setting.dart';
import 'package:manga_reader_app/core/utils/setting_utils.dart';
import 'package:manga_reader_app/core/widget/app_dialog.dart';
import 'package:manga_reader_app/data/app_colors.dart';
import 'package:manga_reader_app/ui/user/in_app_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ValueNotifier<bool> isDarkMode = ValueNotifier(false);
  final ValueNotifier<bool> isShowNotification = ValueNotifier(false);
  final androidId = AppConfig.androidId;
  final appleId = AppConfig.iosId;

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Container(
      height: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: appColor.primaryBackground,
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
                    fontSize: 22,
                    color: appColor.primaryBlack,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 32),
            ValueListenableBuilder<bool>(
                valueListenable: AppSettingData().userPremium,
                builder: (context, value, child) {
                  return Visibility(
                    visible: !value,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InAppPage()));
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            backgroundColor: Colors.transparent),
                        child: Container(
                          width: double.maxFinite,
                          height: 53,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: const LinearGradient(colors: [
                                Color(0xffFF9171),
                                Color(0xffFF5E5E),
                              ])),
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
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        )),
                  );
                }),
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppImage.icDarkMode),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Dark Mode",
                            style: AppStyle.mainStyle.copyWith(
                                fontSize: 16,
                                color: const Color(0xff333333),
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
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppImage.icNotification),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Notification",
                            style: AppStyle.mainStyle.copyWith(
                                fontSize: 16,
                                color: const Color(0xff333333),
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
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    "About Us",
                    AppImage.icStar,
                    onTap: () {
                      _launchUrl(url: AppConfig.urlFacebook);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    "Share App",
                    AppImage.icShare,
                    onTap: () {
                      var url = Platform.isAndroid
                          ? AppConfig.urlStoreAndroid
                          : AppConfig.urlStoreIos;
                      Share.share('Download and reading manga on $url');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    "Rating",
                    AppImage.icRating,
                    onTap: () {
                      StoreRedirect.redirect(
                        androidAppId: androidId,
                        iOSAppId: appleId,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    "Join - Facebook Support",
                    AppImage.icFB,
                    onTap: () {
                      _launchUrl(url: AppConfig.urlFacebook);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    "Term of Privacy",
                    AppImage.icTerm,
                    onTap: () {
                      _launchUrl();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    "Clear Caches",
                    AppImage.icDeleteCache,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              backgroundColor: appColor.backgroundWhite2,
                              content: AppDialog.buildDialog(
                                context,
                                "Do You Want To Clear Caches?",
                                yes: () {
                                  Navigator.of(context).pop();
                                  EasyLoading.showSuccess(
                                      'Clear Caches success');
                                },
                                no: () {
                                  Navigator.of(context).pop();
                                },
                              )));
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

  Future<void> _launchUrl({String? url}) async {
    if (!await launchUrl(
      Uri.parse(url ?? AppConfig.urlTerm),
      mode: LaunchMode.externalApplication,
    )) {
      EasyLoading.showError("Can not open link");
    }
  }

  Widget _buildItem(String content, String iconPath,
      {required VoidCallback onTap, bool? switchTab}) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                content,
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 16,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
