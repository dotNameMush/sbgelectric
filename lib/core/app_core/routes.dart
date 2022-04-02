import 'package:sbgelectric/core/app_core/platform.dart';
import 'package:sbgelectric/webview/admin/admin_login.dart';
import 'package:sbgelectric/webview/admin/admin_panel.dart';
import 'package:sbgelectric/webview/admin/not_admin.dart';
import 'package:sbgelectric/webview/product/product.dart';

var appRoutes = {
  '/': (context) => const PlatformCheck(),
  '/products': (context) => const ProductScreen(),
  '/admin-login': (context) => const AdminLoginScreen(),
  '/not-admin': (context) => const NotAdminErrorScreen(),
  '/admin-panel': (context) => const AdminScreen(),
};
