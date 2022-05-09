import 'package:flutter/material.dart';

import '../core/shared/shared.dart';
import '../services/firestore.dart';
import '../services/models.dart';

class MobileProducts extends StatelessWidget {
  const MobileProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бүх Бараа'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8F8F8),
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Бараа',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 60,
              child: const CategoryWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: FirestoreService().getItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var categories = snapshot.data!;

          return Wrap(
            children: categories
                .map((category) => SalesCardWidget(item: category))
                .toList(),
          );
        } else {
          return const Text('No Category found in Firestore. Check database');
        }
      },
    );
  }
}

class SalesCardWidget extends StatelessWidget {
  final Item item;
  const SalesCardWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
            width: width - 40,
            height: 320,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(item.img), fit: BoxFit.cover)),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(5),
            height: 80,
            width: width - 40,
            child: Column(
              children: [
                Text(
                  item.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  item.price,
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
