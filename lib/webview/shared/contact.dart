import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactWidget extends StatelessWidget {
  const ContactWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 35),
      height: 600,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/contact.png'), fit: BoxFit.fitHeight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Холбоо барих',
            style: TextStyle(
                fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Дараах холбоосууд дээр дарж бидэнтэй холбогдоорой!',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ContactBoxButton(
                icon: Icons.location_on,
                text: 'Шинэ Айл худалдааны төв',
                routeName: 'https://goo.gl/maps/KDKn5a4Yuh8hJc747',
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
            onTap: () => launch('https://www.facebook.com/sanjaa0403'),
            child: const Icon(
              Icons.facebook_outlined,
              color: Colors.white,
              size: 83,
            ),
          ),
        ],
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
