import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:manga_fox_app/app_config.dart';
import 'package:manga_fox_app/core/app_config/app_image.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/utils/screen_brightness_util.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:store_redirect/store_redirect.dart';

class BottomSheetSettingMoreOption extends StatefulWidget {
  final int type; //
  final VoidCallback share;
  final VoidCallback remove;
  final VoidCallback read;

  const BottomSheetSettingMoreOption(
      {Key? key,
      required this.type,
      required this.share,
      required this.remove,
      required this.read})
      : super(key: key);

  @override
  State<BottomSheetSettingMoreOption> createState() =>
      _BottomSheetSettingMoreOptionState();
}

class _BottomSheetSettingMoreOptionState
    extends State<BottomSheetSettingMoreOption> {
  var brightness = 1.0;
  var isHorizontal = true;
  final brightnessUtil = ScreenBrightUtil();
  final settingUtils = SettingUtils();

  @override
  void initState() {
    super.initState();
    currentData();
  }

  Future currentData() async {
    brightness = (await brightnessUtil.currentBrightness);
    isHorizontal = (await settingUtils.horizontal);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return SizedBox(
      height: 240,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "More Option",
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: appColor.primaryBlack2),
                  ),
                )
              ]),
          const SizedBox(height: 32),
          InkWell(
            onTap: widget.read,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                SvgPicture.asset(AppImage.icReadNow,
                    color: appColor.primaryBlack2),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Read now",
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: appColor.primaryBlack2),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          // const SizedBox( height: 20),
          //  InkWell(
          //    onTap: () {
          //
          //    },
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const SizedBox(width: 20),
          //       SvgPicture.asset(AppImage.icBook, color: appColor.primaryBlack2),
          //       const SizedBox(width: 12),
          //        Expanded(
          //         child: Text(
          //           "Book information",
          //           style: AppStyle.mainStyle.copyWith(
          //               fontSize: 12,
          //               fontWeight: FontWeight.w500,
          //               color: appColor.primaryBlack2),
          //         ),
          //       ),
          //       const SizedBox(width: 20),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 20),
          InkWell(
            onTap:() {
              LaunchReview.launch(
                androidAppId: AppConfig.androidId,
                iOSAppId: AppConfig.iosId,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                SvgPicture.asset(AppImage.icShare,
                    color: appColor.primaryBlack2),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Share",
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: appColor.primaryBlack2),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: widget.remove,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                SvgPicture.asset(AppImage.icRemove,
                    color: appColor.primaryBlack2),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Remove from ${widget.type == 1 ? "favorites" : widget.type == 2 ? "downloads" : "historys"}",
                    style: AppStyle.mainStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: appColor.primaryBlack2),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
