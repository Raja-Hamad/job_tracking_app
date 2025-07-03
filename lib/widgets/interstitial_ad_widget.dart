import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdHelper {
  static InterstitialAd? _interstitialAd;

  static void loadInterstitialAd() {
    InterstitialAd.load(
adUnitId: 'ca-app-pub-3940256099942544/1033173712', // ✅ Official Interstitial Test ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print("Interstitial Ad failed to load: ${error.message}");
          }
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          if (onAdClosed != null) onAdClosed();
          loadInterstitialAd(); // Preload for next time
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          if (onAdClosed != null) onAdClosed();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      if (onAdClosed != null) onAdClosed();
      loadInterstitialAd();
    }
  }
}
