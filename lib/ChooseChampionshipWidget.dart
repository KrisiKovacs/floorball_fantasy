import 'dart:collection';

import 'package:floorball_fantasy/menus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BajnoksagValasztoWidget extends StatefulWidget {
  @override
  _BajnoksagValasztoWidgetState createState() =>
      _BajnoksagValasztoWidgetState();
}

class _BajnoksagValasztoWidgetState extends State<BajnoksagValasztoWidget> {
  Map<String, int> bajnoksagokEsAzonositoik = new Map();

  @override
  void initState() {
    super.initState();
    bajnoksagokEsAzonositoikHtmlRead().then((value) {
      setState(() {
        bajnoksagokEsAzonositoik = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return bajnoksagokEsAzonositoik.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: bajnoksagokEsAzonositoik.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(bajnoksagokEsAzonositoik.keys.elementAt(index)),
                onTap: () {
                  onBajnoksagTap(index);
                },
              );
            });
  }

  void onBajnoksagTap(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => JatekosListaWidget(
              bajnoksagId: bajnoksagokEsAzonositoik.values.elementAt(index),
            )));
  }
}

Future<Map<String, int>> bajnoksagokEsAzonositoikHtmlRead() async {
  Map<String, int> bajnoksagokEsAzonositoikValasz = new Map<String, int>();

  var document;
  var response = await http.get(Uri.parse(
      "http://hunfloorball.hu/index.php?ch_id=2&pg=floorball_matches&year=2122"));
  if (response.statusCode == 200) {
    document = response.body;
  }
  List<String> kodElejeLevagasSeged = document.split(
      "<select name=\"ch_id\" id=\"ch_id\" class=\"form-control select-red\" onchange=\"document.getElementById('championship_form').submit();\">");
  kodElejeLevagasSeged.removeAt(0);

  List<String> kodVegeLevagasSeged = kodElejeLevagasSeged[0].split("</select>");
  String bajnoksagokEsAzonositoikSeged = kodVegeLevagasSeged[0];
  List<String> seged = bajnoksagokEsAzonositoikSeged.split("<option");
  seged.removeAt(0);
  seged.forEach((element) {
    List<String> belsoSeged =
        element.split("selected").last.split("value=\"").last.split("\">");
    int value = int.parse(belsoSeged.first);
    String key = belsoSeged.last.split("&nbsp;").last.split("</option>").first;
    bajnoksagokEsAzonositoikValasz[key] = value;
  });
  return bajnoksagokEsAzonositoikValasz;
}
