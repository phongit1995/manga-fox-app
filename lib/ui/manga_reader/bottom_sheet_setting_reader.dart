import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_reader_app/core/app_config/app_image.dart';
import 'package:manga_reader_app/core/app_config/app_style.dart';
import 'package:manga_reader_app/core/utils/screen_brightness_util.dart';
import 'package:manga_reader_app/core/utils/setting_utils.dart';
import 'package:manga_reader_app/data/app_colors.dart';

class BottomSheetSettingReader extends StatefulWidget {
  const BottomSheetSettingReader({Key? key}) : super(key: key);

  @override
  State<BottomSheetSettingReader> createState() =>
      _BottomSheetSettingReaderState();
}

class _BottomSheetSettingReaderState extends State<BottomSheetSettingReader> {
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
      height: 180,
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
                  "Reading Derection",
                  style: AppStyle.mainStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: appColor.primaryBlack2),
                ),
              ),
              const SizedBox(width: 32),
              InkWell(
                onTap: () {
                  settingUtils.setHorizontal(true);
                  setState(() {
                    isHorizontal = true;
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset(AppImage.icHorizontal, color: isHorizontal ? const Color(0xffFF734A) : appColor.primaryBlack2,),
                    const SizedBox(height: 4),
                    Text(
                      "Horizontal",
                      style: AppStyle.mainStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: isHorizontal ? const Color(0xffFF734A) : appColor.primaryBlack2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  settingUtils.setHorizontal(false);
                  setState(() {
                    isHorizontal = false;
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AppImage.icVertical,
                      color: !isHorizontal ? const Color(0xffFF734A) : appColor.primaryBlack2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Vertical",
                      style: AppStyle.mainStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        color: !isHorizontal ? const Color(0xffFF734A) : appColor.primaryBlack2,),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Text(
                "Brightness",
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: appColor.primaryBlack2),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Slider(
                  value: brightness,
                  inactiveColor: appColor.primaryBlack,
                  onChanged: (double nvalue) {
                    setState(() {
                      brightness = nvalue;
                      brightnessUtil.setBrightness(nvalue);
                    });
                  },
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
        ],
      ),
    );
  }
}
