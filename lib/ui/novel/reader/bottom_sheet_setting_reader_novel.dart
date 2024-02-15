import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/app_config/theme/theme_data.dart';
import 'package:manga_fox_app/core/utils/screen_brightness_util.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class BottomSheetSettingReaderNovel extends StatefulWidget {
  const BottomSheetSettingReaderNovel({Key? key}) : super(key: key);

  @override
  State<BottomSheetSettingReaderNovel> createState() =>
      _BottomSheetSettingReaderNovelState();
}

class _BottomSheetSettingReaderNovelState
    extends State<BottomSheetSettingReaderNovel> {
  var brightness = 1.0;
  var fontSize = 13.0;
  final brightnessUtil = ScreenBrightUtil();
  final settingUtils = SettingUtils();

  @override
  void initState() {
    super.initState();
    currentData();
  }

  Future currentData() async {
    brightness = (await brightnessUtil.currentBrightness);
    fontSize = (await settingUtils.getFontSizeNovel());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: appColor.backgroundWhite2,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Text(
                "Font Size",
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: appColor.primaryBlack2),
              ),
              const SizedBox(width: 10),
              Text(
                "Aa",
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: appColor.primaryBlack2),
              ),
              Expanded(
                child: Slider(
                  value: fontSize,
                  inactiveColor: appColor.primaryBlack,
                  min: 9,
                  max: 20,
                  onChanged: (double nvalue) {
                    setState(() {
                      fontSize = nvalue;
                      settingUtils.setFontSizeNovel(nvalue);
                    });
                  },
                ),
              ),
              Text(
                "Aa",
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: appColor.primaryBlack2),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Text(
                "Dark Mode",
                style: AppStyle.mainStyle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: appColor.primaryBlack2),
              ),
              Expanded(
                  child: ValueListenableBuilder<ThemeData>(
                valueListenable: AppThemData().themeData,
                builder: (context, value, child) => Row(
                  children: [
                    const SizedBox(width: 30),
                    InkWell(
                      onTap: () {
                        SettingUtils().setDartMode(false);
                        AppThemData().themeData.value = AppThemData.light;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: value != AppThemData.light
                                    ? const Color(0xffD9D9D9)
                                    : const Color(0xff2079FF)),
                          ),
                          const SizedBox(width: 9),
                          Text(
                            "Light",
                            style: AppStyle.mainStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: appColor.primaryBlack2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 49),
                    InkWell(
                      onTap: () {
                        SettingUtils().setDartMode(true);
                        AppThemData().themeData.value = AppThemData.dark;
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: value != AppThemData.dark
                                    ? const Color(0xffD9D9D9)
                                    : const Color(0xff2079FF)),
                          ),
                          const SizedBox(width: 9),
                          Text(
                            "Dark",
                            style: AppStyle.mainStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: appColor.primaryBlack2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              )),
              const SizedBox(width: 20),
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
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: appColor.primaryBlack2),
              ),
              const SizedBox(width: 10),
              Opacity(
                opacity: 0,
                child: Text(
                  "Aa",
                  style: AppStyle.mainStyle.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: appColor.primaryBlack2),
                ),
              ),
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
              Opacity(
                opacity: 0,
                child: Text(
                  "Aa",
                  style: AppStyle.mainStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: appColor.primaryBlack2),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }
}
