import 'package:floorball_fantasy/ChooseChampionshipWidget.dart';
import 'package:floorball_fantasy/player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'menus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: BajnoksagValasztoWidget(),
      ),
    );
  }
}
