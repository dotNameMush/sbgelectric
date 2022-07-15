import 'package:flutter/material.dart';
import 'package:sbgelectric/webview/shared/contact.dart';
import 'package:sbgelectric/webview/shared/footer.dart';
import 'package:sbgelectric/webview/shared/navigation-drawer.dart';
import 'package:sbgelectric/webview/shared/products.dart';
import 'package:sbgelectric/webview/shared/header.dart';
import 'package:sbgelectric/webview/shared/hero.dart';

class WebHomeView extends StatefulWidget {
  const WebHomeView({Key? key}) : super(key: key);

  @override
  State<WebHomeView> createState() => _WebHomeViewState();
}

class _WebHomeViewState extends State<WebHomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const NavigationDrawer(),
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(scaffoldKey: _scaffoldKey),
              const HeroWidget(),
              const HomeProductsWidget(),
              const SizedBox(height: 54),
              const ContactWidget(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
