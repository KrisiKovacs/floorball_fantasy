import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'player.dart';

class PlayerListWidget extends StatefulWidget {
  final int bajnoksagId;
  final bool fromMyTeamWidget;
  final List<Jatekos> myPlayers;

  PlayerListWidget(
      {Key key, this.bajnoksagId, this.fromMyTeamWidget, this.myPlayers})
      : super(key: key);

  @override
  _PlayerListWidgetState createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  List<Jatekos> jatekosok;
  List<Jatekos> myPlayers;

  @override
  void initState() {
    super.initState();
    myPlayers = widget.myPlayers;
    htmlRead().then((jat) {
      setState(() {
        jatekosok = jat;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (jatekosok == null)
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
                        itemCount: jatekosok.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return index == 0
                              ? Container(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Text("Név"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("Csapat"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("Gól"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("Assziszt"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("Kiállítás"),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text("Ár"),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        widget.fromMyTeamWidget
                                            ? IconButton(
                                                icon: Icon(
                                                  myPlayers.contains(jatekosok
                                                          .elementAt(index - 1))
                                                      ? Icons.remove_circle
                                                      : Icons
                                                          .add_circle_outline,
                                                  color: myPlayers.contains(
                                                          jatekosok.elementAt(
                                                              index - 1))
                                                      ? Colors.red
                                                      : Colors.green,
                                                ),
                                                onPressed: () {
                                                  _onPlusTapped(index - 1);
                                                },
                                              )
                                            : Container(),
                                        Text(
                                            jatekosok.elementAt(index - 1).nev),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text(jatekosok
                                            .elementAt(index - 1)
                                            .csapat),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text(jatekosok
                                            .elementAt(index - 1)
                                            .gol
                                            .toString()),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text(jatekosok
                                            .elementAt(index - 1)
                                            .assziszt
                                            .toString()),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text(jatekosok
                                            .elementAt(index - 1)
                                            .kiallitasPerc
                                            .toString()),
                                        Container(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        Text((jatekosok
                                                    .elementAt(index - 1)
                                                    .price)
                                                .toString() +
                                            "£"),
                                      ],
                                    ),
                                  ),
                                );
                        }),
                  ),
                  height: MediaQuery.of(context).size.height - 100,
                ),
                Container(
                  child: ElevatedButton(
                    child: Text('OK'),
                    onPressed: _onOkPressed,
                  ),
                  height: 100,
                ),
              ],
            ),
    );
  }

  Future<List<Jatekos>> htmlRead() async {
    List<Jatekos> jat = [];
    var document;
    var response = await http.get(Uri.parse(
        "http://hunfloorball.hu/index.php?ch_id=" +
            widget.bajnoksagId.toString() +
            "&pg=floorball_matches&year=2122"));
    if (response.statusCode == 200) {
      document = response.body;
    }
    List<String> seged = document.split("<td align=\"center\">");
    seged.removeAt(0);
    for (int i = 0; i < seged.length; i++) {
      List<String> csapatEsNevSeged =
          seged.elementAt(i).split("<td style=\"text-align:left;\">");
      List<String> szamokSeged =
          csapatEsNevSeged.elementAt(2).split("<td><div align=\"center\">");
      szamokSeged.removeAt(0);
      if (int.tryParse(szamokSeged.elementAt(1).split("<").elementAt(0)) ==
          null) {
        Fluttertoast.showToast(
            msg: "Ez a bajnokság nem indult el!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
        return jat;
      }
      jat.add(new Jatekos(
        csapatEsNevSeged
            .elementAt(1)
            .split("\">")
            .elementAt(1)
            .split("</a>")
            .elementAt(0),
        csapatEsNevSeged
            .elementAt(2)
            .split("\">")
            .elementAt(1)
            .split("</a>")
            .elementAt(0),
        int.parse(szamokSeged.elementAt(0).split("<").elementAt(0)),
        int.parse(szamokSeged.elementAt(1).split("<").elementAt(0)),
        szamokSeged.elementAt(3).split("</div>").elementAt(0) == ""
            ? 0
            : double.parse(szamokSeged.elementAt(3).split(" ").elementAt(0)),
      ));
    }
    return jat;
  }

  void _onPlusTapped(int index) {
    setState(() {
      if (myPlayers.where((jat) {
        return jat == jatekosok.elementAt(index);
      }).isNotEmpty) {
        myPlayers.remove(jatekosok.elementAt(index));
      } else {
        myPlayers.add(jatekosok.elementAt(index));
      }
    });
  }

  void _onOkPressed() {
    Navigator.pop(context, myPlayers);
  }
}
