import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sbgelectric/mobile_view/mobile_drawer.dart';
import 'package:sbgelectric/services/firestore.dart';
import 'package:sbgelectric/services/models.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/shared/shared.dart';

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
      drawer: const MobileDrawer(),
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: ListView(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/mobileHero.png'),
                        fit: BoxFit.fitWidth))),
            Column(
              children: [
                const Text(
                  'Худалдаа',
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(
                  height: 300,
                  child: FutureBuilder<List<Showcase>>(
                    future: FirestoreService().getShowcase(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingScreen();
                      } else if (snapshot.hasError) {
                        return Center(
                          child:
                              ErrorMessage(message: snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        var showcase = snapshot.data!;

                        return CarouselSlider(
                            items: showcase
                                .map((item) => ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    child: Image.network(item.img,
                                        fit: BoxFit.cover, width: 1000.0)))
                                .toList(),
                            options: CarouselOptions(
                              initialPage: 0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              enlargeCenterPage: true,
                            ));
                      } else {
                        return const Text(
                            'No Category found in Firestore. Check database');
                      }
                    },
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/products'),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 200,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]),
                    child: const Center(
                      child: Text(
                        'Бүх барааг харах',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB3B3B3)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 35),
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/contact.png'),
                      fit: BoxFit.fitHeight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Холбоо барих',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Дараах холбоосууд дээр дарж бидэнтэй холбогдоорой!',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ContactBoxButton(
                        icon: Icons.location_on,
                        text: 'БЗД, 5-р хороо, 48г байр',
                        routeName: 'https://goo.gl/maps/LFe82nZf7WxK6EVu7',
                      ),
                      ContactBoxButton(
                        icon: Icons.phone,
                        text: '+976-9904-1895',
                        routeName: 'tel:99041895',
                      ),
                      ContactBoxButton(
                        icon: Icons.mail_outlined,
                        text: 'sanjaa0403@gmail.com',
                        routeName:
                            'mailto:sanjaa0403@gmail.com?subject=subject&body=body',
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => launch('urlString'),
                    child: const Icon(
                      Icons.facebook_outlined,
                      color: Colors.white,
                      size: 83,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContactBoxButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final String routeName;

  const ContactBoxButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.routeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => launch(routeName),
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 75,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: const Color(0xFF004882),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: ListTile(
              leading: Icon(
                icon,
                color: Colors.white,
                size: 54,
              ),
              title: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),
        ));
  }
}
