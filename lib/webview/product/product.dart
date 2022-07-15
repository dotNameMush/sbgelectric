import 'package:flutter/material.dart';
import 'package:sbgelectric/services/models.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatelessWidget {
  final Item item;
  const ProductDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        centerTitle: true,
      ),
      body: Container(
        width: size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 50),
                width: size.width / 5 * 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category + ' / ' + item.name,
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width / 10 * 2.5,
                              height: size.width / 10 * 2.5,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  image: DecorationImage(
                                      image: NetworkImage(item.img))),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 1,
                                  width: size.width / 5 * 1.5,
                                  decoration:
                                      const BoxDecoration(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  item.price + ' ₮',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Container(
                                  height: 1,
                                  width: size.width / 5 * 1.5,
                                  decoration:
                                      const BoxDecoration(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  item.description,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () => launch('http://m.me/sanjaa0403'),
                                  child: Container(
                                    height: 45,
                                    width: 168,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xFF005497)),
                                    child: const Center(
                                      child: Text(
                                        'Захиалах',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 17,
                                ),
                                const Text(
                                  'Хэрхэн захиалах вэ?',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Text(
                                  'Дээрхи “Захиалах” товчин дээр даран messenger-ээр холбогдож\nэсвэл утсаар захиалгаа өгнө үү!',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/shadowLogo.png',
                          width: size.width / 10,
                          height: size.width / 10,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: 1000,
                decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
