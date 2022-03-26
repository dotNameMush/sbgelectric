import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/app_core/routes.dart';
import 'core/app_core/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: appRoutes,
      title: 'Newline',
      theme: appTheme,
    );
  }
}
