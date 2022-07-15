import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';
import 'package:sbgelectric/mobile_view/home.dart';
import 'package:sbgelectric/webview/home.dart';

class PlatformCheck extends StatelessWidget {
  const PlatformCheck({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var device = Theme.of(context).platform;
    if (device == TargetPlatform.windows) {
      return const WebHomeView();
    }
    if (device == TargetPlatform.android || device == TargetPlatform.iOS) {
      return const MobileHomeView();
    } else {
      return const WebHomeView();
    }
  }
}
