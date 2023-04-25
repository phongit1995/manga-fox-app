import 'package:flutter/material.dart';
import 'package:manga_reader_app/core/app_config/app_style.dart';
import 'package:manga_reader_app/data/app_colors.dart';

class AppDialog {
  static Widget buildDialog(
      BuildContext context, String content, {required VoidCallback yes,required VoidCallback no}) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            content,
            maxLines: 2,
            style: AppStyle.mainStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: appColor.primaryBlack2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: no,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffFF734A),
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 8),
                  child: Text(
                    "No",
                    style: AppStyle.mainStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: appColor.backgroundWhite2),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: yes,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffFF734A))
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 8),
                  child: Text(
                    "Yes",
                    style: AppStyle.mainStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: appColor.primaryBlack),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildDialogDelete(
      BuildContext context, String content, {required VoidCallback yes,required VoidCallback no}) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Do You Want To Delete $content",
            maxLines: 2,
            style: AppStyle.mainStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: appColor.primaryBlack2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: no,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffFF734A),
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 8),
                  child: Text(
                    "No",
                    style: AppStyle.mainStyle.copyWith(
                         fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: appColor.backgroundWhite2),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: yes,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xffFF734A))
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 8),
                  child: Text(
                    "Yes",
                    style: AppStyle.mainStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: appColor.primaryBlack),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
