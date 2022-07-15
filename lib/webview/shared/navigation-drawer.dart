import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFF005497),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFF005497),
                    image: const DecorationImage(
                        image: AssetImage('SBGLogo.png'),
                        fit: BoxFit.fitHeight)),
              ),
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/'),
              leading: const Icon(
                Icons.home,
                color: Color(0xFF005497),
                size: 30,
              ),
              title: const Text('Нүүр'),
              trailing: const Icon(
                Icons.arrow_right,
                color: Color(0xFF005497),
                size: 25,
              ),
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/about-web'),
              leading: const Icon(
                FontAwesomeIcons.infoCircle,
                color: Color(0xFF005497),
                size: 30,
              ),
              title: const Text('Бидний тухай'),
              trailing: const Icon(
                Icons.arrow_right,
                color: Color(0xFF005497),
                size: 25,
              ),
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/products'),
              leading: const Icon(
                FontAwesomeIcons.boxes,
                color: Color(0xFF005497),
                size: 30,
              ),
              title: const Text('Бараа'),
              trailing: const Icon(
                Icons.arrow_right,
                color: Color(0xFF005497),
                size: 25,
              ),
            ),
          ],
        ));
  }
}
