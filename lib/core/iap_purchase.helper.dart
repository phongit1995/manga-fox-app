import 'package:in_app_purchase/in_app_purchase.dart';

class IapPurchaseHelper {
  IapPurchaseHelper._internal();

  static final IapPurchaseHelper _singleton = IapPurchaseHelper._internal();

  factory IapPurchaseHelper() {
    return _singleton;
  }

  final InAppPurchase inAppPurchaseInstance = InAppPurchase.instance;
  final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

  Future<void> initStoreInfo() async {
    final InAppPurchase inAppPurchaseInstance = InAppPurchase.instance;
    final bool isAvailable = await inAppPurchaseInstance.isAvailable();
    print('isAvailable ${isAvailable}');
    purchaseUpdated.listen((event) => {print(event)},
        onDone: () => {print('Done Iap')});
    // await this._inAppPurchase.restorePurchases();
  }

  Future<ProductDetailsResponse> getProductDetail(
      List<String> productsId) async {
    return inAppPurchaseInstance.queryProductDetails(productsId.toSet());
  }

  Future<void> buyInapp() async {}
}
