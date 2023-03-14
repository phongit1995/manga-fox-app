
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:manga_fox_app/app_config.dart';

class InappPurchaseHelper {
    final InAppPurchase _inAppPurchase = InAppPurchase.instance;
    List<ProductDetails> _purchases = <ProductDetails>[];
    final Stream purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    Future<void > initStoreInfo ()async {
      final InAppPurchase _inAppPurchase = InAppPurchase.instance;
      final bool isAvailable = await _inAppPurchase.isAvailable();
      print('isAvailable ${isAvailable}');
      final ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails(AppConfig.androidIapSubcription.toSet());
      print('productDetailResponse ${productDetailResponse.productDetails}');
      print(productDetailResponse.productDetails[0].id);
      this._purchases = productDetailResponse.productDetails;
      this.purchaseUpdated.listen((event) => {
        print(event)
      },onDone: ()=>{
        print('Done Iap')
      });
      await this._inAppPurchase.restorePurchases();
    }

    Future<void> buyInapp()async{
      print('buy');
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: this._purchases[0]);
      this._inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
}
final InappPurchaseHelper inappPurchaseHelper = InappPurchaseHelper();