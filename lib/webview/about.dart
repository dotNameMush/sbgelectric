import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: const BoxDecoration(color: Color(0xFF005497)),
            child: const Center(
              child: Text(
                'Бидний тухай',
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
            ),
          ),
          Image.asset('assets/about.png'),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 10,
            decoration: const BoxDecoration(color: Color(0xFF005497)),
          ),
          Image.asset('assets/about2.png')
        ]));
  }
}
