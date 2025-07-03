import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;

@override
void initState() {
  super.initState();

  _bannerAd = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111', // ✅ TEST Ad Unit ID
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (_) {
        setState(() {});
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        if (kDebugMode) {
          print('Ad failed to load: ${error.message}');
        }
      },
    ),
  )..load();
}

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null) return const SizedBox.shrink();

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
