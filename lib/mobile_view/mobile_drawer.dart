import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            DrawerHeader(
                child: Column(
              children: [
                Container(
                  width: 300,
                  height: 100,
                  decoration: const BoxDecoration(color: Color(0xFF005497)),
                  child: Image.asset(
                    'assets/SBGLogo.png',
                    cacheWidth: 80,
                    height: 50,
                  ),
                ),

                // InkWell(
                //   onTap: () => Navigator.pushNamed(context, '/profile'),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Container(
                //         height: 60,
                //         width: 60,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(5),
                //             image: const DecorationImage(
                //                 image: AssetImage('assets/profile.jpg'),
                //                 fit: BoxFit.fill)),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: const [
                //           Text(
                //             '????????????',
                //             style: TextStyle(color: Colors.grey, fontSize: 18),
                //           ),
                //           Text('??????????????????',
                //               style:
                //                   TextStyle(color: Colors.grey, fontSize: 14))
                //         ],
                //       ),
                //       const Expanded(
                //         child: Align(
                //             alignment: Alignment.centerRight,
                //             child: Icon(Icons.settings)),
                //       )
                //     ],
                //   ),
                // ),
              ],
            )),
            Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.home),
                  title: Text('????????'),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, '/about-web'),
                  leading: const Icon(Icons.apartment),
                  title: const Text('???????????? ??????????'),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, '/mobile-products'),
                  leading: const Icon(Icons.shopping_bag),
                  title: const Text('?????? ?????????? ??????????'),
                ),
                const ListTile(
                  leading: Icon(Icons.question_mark),
                  title: Text('???????????? ???????????????? ???????? ?????'),
                ),
                ListTile(
                  onTap: () => launch('https://www.facebook.com/sanjaa0403'),
                  leading: const Icon(Icons.facebook),
                  title: const Text('Facebook ????????????'),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/admin-login'),
                  child: const Text(
                    '??????????????',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  '@2022-Newline Solutions',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
