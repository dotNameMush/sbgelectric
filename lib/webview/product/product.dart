import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sbgelectric/services/firestore.dart';

import '../../core/shared/error.dart';
import '../../core/shared/loading.dart';
import '../../services/models.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бүх бараа'),
      ),
      body: Container(
          decoration: const BoxDecoration(color: Color(0xFFF8F8F8)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Бараа',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 10 * 5,
                          child: const CategoryWidget(),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )),
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

class CategoryItem extends StatelessWidget {
  final Category category;
  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ItemScreen(category: category),
            ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(4, 4)),
                      BoxShadow(
                          color: Colors.white,
                          spreadRadius: 4,
                          blurRadius: 4,
                          offset: Offset(-4, -4)),
                    ]),
                child: const Center(
                  child: Icon(
                    FontAwesomeIcons.shoppingBag,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                category.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}

class ItemScreen extends StatelessWidget {
  final Category category;
  const ItemScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [Text(category.name), Wrap()],
        ),
      ),
    );
  }
}

class SalesCardWidget extends StatelessWidget {
  final Item item;
  const SalesCardWidget({Key? key, required this.item}) : super(key: key);

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
                    image: NetworkImage(item.img), fit: BoxFit.cover)),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(5),
            height: 80,
            width: 230,
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
