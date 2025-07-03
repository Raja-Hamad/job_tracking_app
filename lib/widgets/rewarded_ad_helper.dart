import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdHelper {
  static RewardedAd? _rewardedAd;

  static void loadRewardedAd(VoidCallback onEarnedReward) {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // ✅ Test ad unit
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              onEarnedReward();
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print('RewardedAd failed to load: $error');
          }
        },
      ),
    );
  }
}
