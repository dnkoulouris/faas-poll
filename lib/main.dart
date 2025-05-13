import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:football_as_a_service/src/screens/home.dart';
import 'package:football_as_a_service/src/screens/polls_screen.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'src/screens/poll/poll_screen.dart';

Future<void> main() async {
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Football As A Service',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      getPages: _pages,
    );
  }
}

List<GetPage> _pages = [
  GetPage(
    name: '/',
    page: () {
      return HomeScreen();
    },
  ),
  GetPage(
    name: '/polls',
    page: () {
      return PollsScreen();
    },
  ),
  GetPage(
    name: '/poll/:id',
    page: () {
      return PollScreen();
    },
  ),
];
