import 'package:sbgelectric/core/app_core/platform.dart';
import 'package:sbgelectric/mobile_view/products.dart';
import 'package:sbgelectric/webview/about.dart';
import 'package:sbgelectric/webview/admin/admin_login.dart';
import 'package:sbgelectric/webview/admin/admin_panel.dart';
import 'package:sbgelectric/webview/admin/not_admin.dart';
import 'package:sbgelectric/webview/product/products.dart';

var appRoutes = {
  '/': (context) => const PlatformCheck(),
  '/products': (context) => const ProductScreen(),
  '/admin-login': (context) => const AdminLoginScreen(),
  '/not-admin': (context) => const NotAdminErrorScreen(),
  '/admin-panel': (context) => const AdminScreen(),
  '/about-web': (context) => const AboutScreen(),
  //mobile
  '/mobile-products': (context) => const MobileProducts(),
};
