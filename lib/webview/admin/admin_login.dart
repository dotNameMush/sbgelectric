import 'package:flutter/material.dart';

import '../../core/app_core/auth.dart';
import '../../core/shared/error.dart';
import '../../core/shared/loading.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: ErrorMessage(),
          );
        } else if (snapshot.hasData) {
          return const LoggedInView();
        } else {
          return const LoggedOutView();
        }
      },
    );
  }
}

class LoggedInView extends StatelessWidget {
  const LoggedInView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Админ Цэс'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    child: const Text('signout'),
                    onPressed: () async {
                      await AuthService().signOut();
                    }),
                ElevatedButton(
                    onPressed: () {
                      if (AuthService().checkadmin() == true) {
                        Navigator.pushNamed(context, '/sent-info');
                      } else {
                        Navigator.pushNamed(context, '/not-admin');
                      }
                    },
                    child: const Text('Мэдээлэлүүд харах'))
              ]),
        ));
  }
}

class LoggedOutView extends StatelessWidget {
  const LoggedOutView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Админ Цэс'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => AuthService().googleLogin(),
                    child: const Text('google login')),
              ]),
        ));
  }
}
