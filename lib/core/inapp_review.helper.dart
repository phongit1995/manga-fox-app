import 'package:in_app_review/in_app_review.dart';

class InAppReviewHelper {
  InAppReviewHelper._internal();

  static final InAppReviewHelper _singleton = InAppReviewHelper._internal();
  final InAppReview inAppReview = InAppReview.instance;
  factory InAppReviewHelper() {
    return _singleton;
  }
  Future<void> requestReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
