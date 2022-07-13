import 'package:floorball_fantasy/PlayerListWidget.dart';
import 'package:flutter/material.dart';
import 'player.dart';

class MyTeamWidget extends StatefulWidget {
  final int bajnoksagId;

  const MyTeamWidget({Key key, this.bajnoksagId}) : super(key: key);

  @override
  _MyTeamWidgetState createState() => _MyTeamWidgetState();
}

class _MyTeamWidgetState extends State<MyTeamWidget> {
  List<Jatekos> myPlayers;

  @override
  void initState() {
    super.initState();
    myPlayers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (myPlayers == null)
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
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: myPlayers.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return index == 0
                            ? ListTile(
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
                              )
                            : ListTile(
                                title: Row(
                                  children: [
                                    Text(myPlayers.elementAt(index - 1).nev),
                                    Container(
                                      width: 5,
                                      color: Colors.black,
                                    ),
                                    Text(myPlayers.elementAt(index - 1).csapat),
                                    Container(
                                      width: 5,
                                      color: Colors.black,
                                    ),
                                    Text(myPlayers
                                        .elementAt(index - 1)
                                        .gol
                                        .toString()),
                                    Container(
                                      width: 5,
                                      color: Colors.black,
                                    ),
                                    Text(myPlayers
                                        .elementAt(index - 1)
                                        .assziszt
                                        .toString()),
                                    Container(
                                      width: 5,
                                      color: Colors.black,
                                    ),
                                    Text(myPlayers
                                        .elementAt(index - 1)
                                        .kiallitasPerc
                                        .toString()),
                                    Container(
                                      width: 5,
                                      color: Colors.black,
                                    ),
                                    Text((myPlayers.elementAt(index - 1).price)
                                            .toString() +
                                        "£"),
                                  ],
                                ),
                              );
                      }),
                ),
                Container(
                  child: ElevatedButton(
                    child: Text('Játékos hozzáadása'),
                    onPressed: _onAddPlayerPressed,
                  ),
                )
              ],
            ),
    );
  }

  void _onAddPlayerPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => PlayerListWidget(
                  bajnoksagId: widget.bajnoksagId,
                  myPlayers: myPlayers,
                  fromMyTeamWidget: true,
                )))
        .then((selectedPlayers) {
      setState(() {
        myPlayers = selectedPlayers;
      });
    });
  }
}
