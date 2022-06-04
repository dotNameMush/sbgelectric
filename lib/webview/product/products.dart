import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sbgelectric/services/firestore.dart';

import '../../core/shared/shared.dart';
import '../../services/models.dart';
import 'product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var categoryLength = 12;
  List<Item> _allItems = [];
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    category();
    posts();
  }

  posts() async {
    try {
      var ref = FirebaseFirestore.instance.collection('item');
      var snapshot = await ref.get();
      var data = snapshot.docs.map((e) => e.data());
      var items = data.map((e) => Item.fromJson(e));
      setState(() {
        _allItems = items.toList();
        _items = items.toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      ));
    }
  }

  category() async {
    Future<List<Category>> categories = FirestoreService().getCategory();
    categories.then((value) {
      setState(() {
        categoryLength = value.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бүх бараа'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 30),
          decoration: const BoxDecoration(
            color: Color(0xFFE5E5E5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: size.width / 2,
                      child: const Text(
                        'Бараанууд',
                        style: TextStyle(fontSize: 28),
                      )),
                  Container(
                    width: size.width / 2,
                    padding: EdgeInsets.all(size.width / 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children:
                          _items.map((e) => SalesCardWidget(item: e)).toList(),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: size.width / 5,
                      child: const Text(
                        'Ангилал',
                        style: TextStyle(fontSize: 28),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width / 5,
                    height: categoryLength * 60 + 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: FutureBuilder<List<Category>>(
                      future: FirestoreService().getCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: ErrorMessage(
                                message: snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          var categories = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: categories
                                .map(
                                  (category) => InkWell(
                                    onTap: () => selectCategory(category.name),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.blue)),
                                      child: Center(
                                        child: Text(
                                          category.name,
                                          style: const TextStyle(
                                              color: Colors.blue, fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        } else {
                          return const Text(
                              'No Category found in Firestore. Check database');
                        }
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _items = _allItems;
                      });
                    },
                    child: const SizedBox(
                        height: 50,
                        child: Center(child: Text('Бүх барааг харах'))),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectCategory(String categoryInput) {
    setState(() {
      _items = _allItems;
    });
    final result = _items.where((item) {
      final itemCategory = item.category;
      final input = categoryInput;
      return itemCategory.contains(input);
    }).toList();
    setState(() {
      _items = result;
    });
  }
}

class SalesCardWidget extends StatelessWidget {
  final Item item;
  const SalesCardWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(item: item),
          )),
      child: Container(
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
              width: 250,
              height: 320,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(item.img), fit: BoxFit.cover)),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(5),
              height: 80,
              width: 250,
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
      ),
    );
  }
}
