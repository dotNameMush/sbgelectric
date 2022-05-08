import 'package:flutter/material.dart';
import 'package:sbgelectric/services/firestore.dart';
import 'package:sbgelectric/services/models.dart';

import '../../core/shared/shared.dart';
import 'add_product.dart';

class ProductEdit extends StatelessWidget {
  const ProductEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color(0xFFF8F8F8)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Бараанууд',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddProductScreen(),
                                )),
                            icon: const Icon(Icons.add),
                            label: const Text('Бараа нэмэх'))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: const ProductsWidget(),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 40;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: width / 5 * 2.5,
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
              decoration: BoxDecoration(border: Border.all()),
              child: const Text(
                'Нэр',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: width / 5 * 1,
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
              decoration: BoxDecoration(border: Border.all()),
              child: const Text(
                'Ангилал',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: width / 5 * 1,
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
              decoration: BoxDecoration(border: Border.all()),
              child: const Text(
                'Үнэ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                width: width / 5 * 0.5,
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5),
                decoration: BoxDecoration(border: Border.all()),
                child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('Засах'))),
          ],
        ),
        FutureBuilder<List<Item>>(
          future: FirestoreService().getItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return Center(
                child: ErrorMessage(message: snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              var items = snapshot.data!;

              return Column(
                children: items.map((item) {
                  var width = MediaQuery.of(context).size.width - 40;
                  return Row(
                    children: [
                      Container(
                        width: width / 5 * 2.5,
                        padding:
                            const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                        decoration: BoxDecoration(border: Border.all()),
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        width: width / 5 * 1,
                        padding:
                            const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                        decoration: BoxDecoration(border: Border.all()),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        width: width / 5 * 1,
                        padding:
                            const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                        decoration: BoxDecoration(border: Border.all()),
                        child: Text(
                          item.price,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                          width: width / 5 * 0.5,
                          padding:
                              const EdgeInsets.only(top: 8, bottom: 8, left: 5),
                          decoration: BoxDecoration(border: Border.all()),
                          child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.edit),
                              label: Text('Засах'))),
                    ],
                  );
                }).toList(),
              );
            } else {
              return const Text(
                  'No Category found in Firestore. Check database');
            }
          },
        )
      ],
    );
  }
}
