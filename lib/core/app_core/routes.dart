import 'package:sbgelectric/core/app_core/platform.dart';
import 'package:sbgelectric/webview/product/product.dart';

var appRoutes = {
  '/': (context) => const PlatformCheck(),
  '/products': (context) => const ProductScreen(),
};
