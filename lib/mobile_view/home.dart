import 'package:flutter/material.dart';

class MobileHomeView extends StatefulWidget {
  const MobileHomeView({Key? key}) : super(key: key);

  @override
  State<MobileHomeView> createState() => _MobileHomeViewState();
}

class _MobileHomeViewState extends State<MobileHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logotext.png'),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: ListView(
          children: [
            Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/mobileHero.png'),
                        fit: BoxFit.fitWidth))),
          ],
        ),
      ),
    );
  }
}
