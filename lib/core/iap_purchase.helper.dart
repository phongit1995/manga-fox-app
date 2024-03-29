import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:manga_fox_app/core/app_setting.dart';

class IapPurchaseHelper {
  IapPurchaseHelper._internal();

  static final IapPurchaseHelper _singleton = IapPurchaseHelper._internal();

  factory IapPurchaseHelper() {
    return _singleton;
  }

  final InAppPurchase inAppPurchaseInstance = InAppPurchase.instance;
  final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
  late StreamSubscription subscription;

  Future<void> initStoreInfo() async {
    final bool isAvailable = await inAppPurchaseInstance.isAvailable();
    subscription = purchaseUpdated.listen((event) {
      listenToPurchaseUpdated(event);
    }, onDone: () => {subscription.cancel()}, onError: (Object error) {});
    try {
      await inAppPurchaseInstance.restorePurchases();
    } catch (e) {
      print(e);
    }
    
    
  }

  Future<ProductDetailsResponse> getProductDetail(
      List<String> productsId) async {
    return inAppPurchaseInstance.queryProductDetails(productsId.toSet());
  }

  Future<void> buyIap(PurchaseParam purchaseParam) async {
    inAppPurchaseInstance.buyConsumable(purchaseParam: purchaseParam);
  }

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
            AppSettingData().updateIsVip(true);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }
  Future<void> restorePurchases() async {
    await inAppPurchaseInstance.restorePurchases();
  }
  void disposeIap() {
    subscription.cancel();
  }
}
