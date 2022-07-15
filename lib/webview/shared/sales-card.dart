import 'package:flutter/material.dart';

import '../../services/models.dart';

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
