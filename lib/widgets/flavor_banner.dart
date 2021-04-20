import 'package:flutter/material.dart';
import 'package:flutter_template/config/flavor_config.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  BannerConfig? bannerConfig;

  FlavorBanner({required this.child});

  @override
  Widget build(BuildContext context) {
    if(FlavorConfig.isProduction()) return child;

    bannerConfig ??= _getDefaultBanner();

    return Stack(
      children: <Widget>[
        child,
        _buildBanner(context)
      ],
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
        bannerName: FlavorConfig.flavorName,
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
            message: bannerConfig!.bannerName,
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.topStart,
            color: Colors.purple
        ),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;

  BannerConfig({required this.bannerName});
}