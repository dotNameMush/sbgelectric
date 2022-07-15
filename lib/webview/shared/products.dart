import 'package:flutter/material.dart';
import 'package:sbgelectric/core/shared/shared.dart';

import '../../services/firestore.dart';
import '../../services/models.dart';
import '../home.dart';
import 'sales-card.dart';

class HomeProductsWidget extends StatelessWidget {
  const HomeProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Худалдаа',
            style: TextStyle(color: Colors.black, fontSize: 48)),
        Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height / 2,
          child: FutureBuilder<List<Showcase>>(
            future: FirestoreService().getShowcase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: ErrorMessage(message: snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                var showcase = snapshot.data!;

                return Wrap(
                  children: showcase
                      .map((showcase) => SalesCardWidget(showcase: showcase))
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
          onTap: () => Navigator.pushNamed(context, '/products'),
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: 200,
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(1, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.80),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(-1, -2),
                  )
                ]),
            child: const Center(
              child: Text(
                'Бүх барааг харах',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 133, 133, 133)),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }
}
