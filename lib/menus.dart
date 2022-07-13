import 'package:floorball_fantasy/GWMatchesWidget.dart';
import 'package:floorball_fantasy/MyTeamWidget.dart';
import 'package:flutter/material.dart';

import 'PlayerListWidget.dart';

class JatekosListaWidget extends StatefulWidget {
  final int bajnoksagId;

  JatekosListaWidget({Key key, this.bajnoksagId}) : super(key: key);

  @override
  _JatekosListaWidgetState createState() => _JatekosListaWidgetState();
}

class _JatekosListaWidgetState extends State<JatekosListaWidget> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.run_circle_rounded),
            label: 'Player stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_rounded),
            label: 'My team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_hockey_rounded),
            label: 'Upcoming matches',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _selectedWidget() {
    if (_selectedIndex == 0) {
      return PlayerListWidget(
          bajnoksagId: widget.bajnoksagId, fromMyTeamWidget: false);
    } else if (_selectedIndex == 1) {
      return MyTeamWidget(bajnoksagId: widget.bajnoksagId);
    } else
      return GWMatchesWidget(bajnoksagId: widget.bajnoksagId);
  }
}
