import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                IconButton(
                  onPressed: () => {_scaffoldKey.currentState!.openDrawer()},
                  icon: const Icon(FontAwesomeIcons.bars),
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
      ],
    );
  }
}
