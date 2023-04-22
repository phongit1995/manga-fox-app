import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:manga_fox_app/app_config.dart';
import 'package:manga_fox_app/core/app_config/app_style.dart';
import 'package:manga_fox_app/core/iap_purchase.helper.dart';
import 'package:manga_fox_app/data/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InAppPage extends StatefulWidget {
  const InAppPage({super.key});

  @override
  State<InAppPage> createState() => _InAppPageState();
}

class _InAppPageState extends State<InAppPage> {
  List<ProductDetails> purchases = <ProductDetails>[];

  int selectedIap = -1;

  @override
  initState() {
    super.initState();
    intStateIap();
  }

  Future<void> intStateIap() async {
    final res =
        await IapPurchaseHelper().getProductDetail(AppConfig.iapSubscription);
    if (res.productDetails.isNotEmpty) {
      setState(() {
        purchases = res.productDetails;
        selectedIap = 0;
      });
    }
  }
  Future<void> _launchUrl({String? url}) async {
    if (!await launchUrl(
      Uri.parse(url ?? AppConfig.urlTerm),
      mode: LaunchMode.externalApplication,
    )) {
      EasyLoading.showError("Can not open link");
    }
  }
  @override
  Widget build(BuildContext context) {
    final AppColor appColor = Theme.of(context).extension<AppColor>()!;
    return Container(
      decoration: BoxDecoration(
        color: appColor.primaryBackground
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: selectedIap != -1,
              child: ElevatedButton(
                  onPressed: () async {
                    final PurchaseParam purchaseParam =
                        PurchaseParam(productDetails: purchases[selectedIap]);
                    await IapPurchaseHelper().buyIap(purchaseParam);
                  },
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
                      "BECOME VIP",
                      style: AppStyle.mainStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  )),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: (){
                IapPurchaseHelper().restorePurchases();
                Fluttertoast.showToast(
                  msg: "Restore Purchase Success",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 16.0
                );
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Restore purchase",
                  style: AppStyle.mainStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      fontSize: 11),
                ),
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
                        color: appColor.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 26),
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
                  const SizedBox(height: 20),
                  ListView.builder(
                    itemCount: purchases.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedIap = index;
                              });
                            },
                            child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        purchases[index].id ==
                                                AppConfig.iapSubscription[0]
                                            ? "1 Month"
                                            : "1 Year",
                                        style: AppStyle.mainStyle.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${purchases[index].id == AppConfig.iapSubscription[0] ? "30" : "365"} days VIP",
                                        style: AppStyle.mainStyle.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 8),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    purchases[index].price,
                                    style: AppStyle.mainStyle.copyWith(
                                        color: const Color(0xffFF734A),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  Visibility(
                                    visible: index == selectedIap,
                                    child: Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.ac_unit,
                                          color: Colors.greenAccent[400],
                                          size: 28,
                                        )),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 30),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Terms of Use ' ,style: AppStyle.mainStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 14), 
                        recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url:'https://doc-hosting.flycricket.io/manga-reader-terms-of-use/74be8290-d856-4319-8366-c4bdcd7bfc26/terms'),
                        ),
                          TextSpan(text: ' & ', style: AppStyle.mainStyle.copyWith(
                        color: const Color(0xffFF734A),
                        fontWeight: FontWeight.w300,
                        fontSize: 14),),
                          TextSpan(text: 'Privacy Policy',style: AppStyle.mainStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 14),
                        recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url:AppConfig.urlTerm))
                        ]
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text('- Payment will be charged to your Apple account at confirmation of purchase (after you accept by single-touch identification, facial recognition, or otherwise the subscription terms on the pop-up screen provided by Apple',style: AppStyle.mainStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),),
                  Text('- You can cancel the subscription anytime by turning off auto-renewal through your Account settings.',style: AppStyle.mainStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),),
                  Text('To avoid being charged, cancel the subscription in your Account settings at least 24 hours before the end of the current subscription period.',style: AppStyle.mainStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),),
                  Text('You alone can manage your subscription. Learn more about managing subscriptions (and how to cancel them) on Apple support page.',style: AppStyle.mainStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),),
                  Text("If you purchased a subscription through the Apple Store and are eligible for a refund, you'll have to request it directly from Apple. To request a refund, follow these instructions from the Apple's support page.",style: AppStyle.mainStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),)
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
