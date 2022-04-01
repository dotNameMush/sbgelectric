import 'package:flutter/material.dart';

class NotAdminErrorScreen extends StatelessWidget {
  const NotAdminErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Та нэвтрэх эрхгүй хэрэглэгч байна'),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const Text('Буцах'))
        ],
      ),
    ));
  }
}
