import 'package:flutter/material.dart';
import 'main.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _index = 0;
  final List<Widget> _widget = <Widget>[
    MyHomePage(),
    const Text('2'),
    const Text('3'),
    const Text('4'),
  ];

  void _onItemTap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.teal,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_rounded),
          label: 'Messages',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Timeline',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        )
      ],
      onTap: _onItemTap,
    );
  }
}
