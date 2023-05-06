import 'dart:io';
import 'package:flutter/material.dart';

import 'api/override_http.dart';
// import 'package:teste_api/pages/home.dart';
import 'package:teste_api/pages/home_list.dart';
//import 'package:teste_api/pages/home_listtile.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
