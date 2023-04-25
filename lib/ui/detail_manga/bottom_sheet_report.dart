import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:manga_reader_app/core/app_config/app_style.dart';
import 'package:manga_reader_app/data/app_colors.dart';

class BottomSheetReport extends StatefulWidget {
  const BottomSheetReport({Key? key}) : super(key: key);

  @override
  State<BottomSheetReport> createState() => _BottomSheetReportState();
}

class _BottomSheetReportState extends State<BottomSheetReport> {
  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;

    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 22),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              "Report",
              style: AppStyle.mainStyle.copyWith(
                  fontSize: 20,
                  color: appColor.primaryBlack2,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                EasyLoading.showSuccess('Report success');
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  alignment: Alignment.centerRight),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric( vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffFF734A)),
                child: Text(
                  "Sensitive Content",
                  style: AppStyle.mainStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
              )),
          // const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                EasyLoading.showSuccess('Report success');
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  alignment: Alignment.centerRight),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric( vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffFF734A)),
                child: Text(
                  "The story has no content",
                  style: AppStyle.mainStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
              )),
          // const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                EasyLoading.showSuccess('Report success');
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  alignment: Alignment.centerRight),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric( vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffFF734A)),
                child: Text(
                  "Others",
                  style: AppStyle.mainStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
              )),
          // const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  alignment: Alignment.centerRight),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric( vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffFF734A)),
                child: Text(
                  "Cancel",
                  style: AppStyle.mainStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
