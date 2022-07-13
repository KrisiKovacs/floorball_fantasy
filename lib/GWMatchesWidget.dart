import 'package:floorball_fantasy/match.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'player.dart';
import 'package:floorball_fantasy/ChooseChampionshipWidget.dart';
import 'dart:core';

class GWMatchesWidget extends StatefulWidget {
  final int bajnoksagId;
  final List<Match> GWMatches;

  GWMatchesWidget({Key key, this.bajnoksagId, this.GWMatches})
      : super(key: key);

  @override
  _GWMatchesWidgetState createState() => _GWMatchesWidgetState();
}

class _GWMatchesWidgetState extends State<GWMatchesWidget> {
  List<Match> GWMatches;

  @override
  void initState() {
    super.initState();
    GWMatches = widget.GWMatches;
    GWmatchesHtmlRead().then((GWM) {
      setState(() {
        GWMatches = GWM;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (GWMatches == null)
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: GWMatches.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return index == 0
                              ? Container(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Text("Ford."),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("Dátum"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("Hazai"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("-"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("Vendég"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Container(),
                                        Text(GWMatches.elementAt(index - 1)
                                            .round
                                            .toString()),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text(GWMatches.elementAt(index - 1)
                                            .homeTeam),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text(' - '),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text(GWMatches.elementAt(index - 1)
                                            .guestTeam),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        }),
                  ),
                  height: MediaQuery.of(context).size.height - 100,
                ),
              ],
            ),
    );
    ;
  }

  Future<List<Match>> GWmatchesHtmlRead() async {
    List<Match> GWmatches = new List<Match>();

    var document;
    var response = await http.get(Uri.parse(
        "http://hunfloorball.hu/index.php?ch_id=" +
            widget.bajnoksagId.toString() +
            "&pg=floorball_matches&year=2122"));
    if (response.statusCode == 200) {
      document = response.body;
    }
    List<String> cut = document.split('<tr class="height-40">');
    cut.removeAt(0);
    cut.removeAt(0);
    //cut.removeAt(cut.length - 1); //A legrégebi meccsre ki kell még találni valamit!

    List<String> insideCut = new List<String>();
    List<String> actualTeams = new List<String>();

    cut.forEach((element) {
      if (element == cut[cut.length - 1]) {
        element = element.split(
            '<td class="font-size-15 font-size-12"><a href="index.php?pg=floorball_match')[0];
      }
      insideCut = element.split("</td>");
      Match actualMatch = new Match(0, '2022', '-', '-', '-');

      actualMatch.round = int.parse(
          insideCut[0].substring(insideCut[0].length - 1, insideCut[0].length));
      actualMatch.date =
          insideCut[1].substring(insideCut[1].length - 13, insideCut[1].length);

      actualTeams = insideCut[2]
          .split('</a> - <a href="index.php?pg=floorball_team_data&team_id=');

      actualMatch.homeTeam =
          actualTeams[0].split('>')[actualTeams[0].split('>').length - 1];
      actualMatch.guestTeam = actualTeams[1]
          .split('>')[1]
          .substring(0, actualTeams[1].split('>')[1].length - 3);
      actualMatch.result =
          insideCut[3].substring(insideCut[3].length - 3, insideCut[3].length);

      if (GWmatches.where((match) {
        return match == actualMatch;
      }).isEmpty) {
        //if (actualMatch.result == '-') {
        GWmatches.add(actualMatch);
      }
    });
    return GWmatches;
  }
}
