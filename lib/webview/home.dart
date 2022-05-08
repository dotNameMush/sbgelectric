import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sbgelectric/services/models.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/shared/error.dart';
import '../core/shared/loading.dart';
import '../services/firestore.dart';

class WebHomeView extends StatefulWidget {
  const WebHomeView({Key? key}) : super(key: key);

  @override
  State<WebHomeView> createState() => _WebHomeViewState();
}

class _WebHomeViewState extends State<WebHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFF004882),
              ),
            ),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFF005497),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 5,
                    left: MediaQuery.of(context).size.width / 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/logotext.png',
                          height: 50,
                          isAntiAlias: true,
                        ),
                      ],
                    ),
                    const Icon(
                      FontAwesomeIcons.bars,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFFF9900),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 35),
              height: 400,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/hero.png'),
                      fit: BoxFit.fitHeight)),
            ),
            Column(
              children: [
                const Text('Худалдаа',
                    style: TextStyle(color: Colors.black, fontSize: 48)),
                FutureBuilder<List<Showcase>>(
                  future: FirestoreService().getShowcase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingScreen();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: ErrorMessage(message: snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      var showcase = snapshot.data!;

                      return Wrap(
                        children: showcase
                            .map((showcase) =>
                                SalesCardWidget(showcase: showcase))
                            .toList(),
                      );
                    } else {
                      return const Text(
                          'No Category found in Firestore. Check database');
                    }
                  },
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
                            offset: const Offset(1, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.80),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(-1, -2),
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
                const SizedBox(
                  height: 25,
                )
              ],
            ),
            const SizedBox(
              height: 54,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 35),
              height: 600,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/contact.png'),
                      fit: BoxFit.fitHeight)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Холбоо барих',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Text(
                    'Дараах холбоосууд дээр дарж бидэнтэй холбогдоорой!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  Row(
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
                        routeName: 'tel:<99041895>',
                      ),
                      ContactBoxButton(
                        icon: Icons.mail_outlined,
                        text: 'sanjaa0403@gmail.com',
                        routeName:
                            'mailto:<sanjaa0403@gmail.com>?subject=<subject>&body=<body>',
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => launch(
                        'https://www.facebook.com/SBG-Spare-Parts-Sale-Center-Air-Conditioning-Electrical-2109176542744739'),
                    child: const Icon(
                      Icons.facebook_outlined,
                      color: Colors.white,
                      size: 83,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              height: 7,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFFF9900),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 585,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[Color(0xff005497), Color(0xff3D89DE)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 84,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/logotext.png'),
                      Container(
                        height: 88,
                        width: MediaQuery.of(context).size.width / 5 * 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(33),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                'Мэйл хаягаа оруулаад шинэ мэдээ, мэдээлэл цаг алгалгүй аваарай',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 180,
                              height: 66,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: <Color>[
                                      Color(0xff005497),
                                      Color(0xff3D89DE)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(33)),
                              child: const Center(
                                child: Text(
                                  'Subscribe',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Холбоос',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: () => Navigator.pushNamed(context, '/'),
                            child: const Text(
                              'Нүүр',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/about-web'),
                            child: const Text(
                              'Бидний тухай',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/admin-login'),
                            child: const Text(
                              'Нэвтрэх',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            ' ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/about-web'),
                            child: const Text(
                              'Үйлчилгээ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () => launch(
                                'https://www.facebook.com/SBG-Spare-Parts-Sale-Center-Air-Conditioning-Electrical-2109176542744739'),
                            child: const Text(
                              'Facebook хуудас',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/products'),
                            child: const Text(
                              'Гадаад худалдаа',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/products'),
                            child: const Text(
                              'Бүх бараа харах',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/products'),
                            child: const Text(
                              'Ангилал',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Хэрхэн худалдан авах вэ?',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Copyright 2022, Newline Solutions',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ]),
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
        height: 150,
        width: MediaQuery.of(context).size.width / 5 - 20,
        decoration: BoxDecoration(
            color: const Color(0xFF004882),
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 64,
            ),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}

class SalesCardWidget extends StatelessWidget {
  final Showcase showcase;
  const SalesCardWidget({Key? key, required this.showcase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 230,
            height: 320,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(showcase.img), fit: BoxFit.cover)),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(5),
            height: 80,
            width: 230,
            child: Column(
              children: [
                Text(
                  showcase.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  showcase.price,
                  style: const TextStyle(color: Colors.blue, fontSize: 18),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
