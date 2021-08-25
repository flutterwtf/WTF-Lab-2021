import 'package:flutter/material.dart';
import 'package:flutter_app_chat_journal/message_page.dart';
import 'add_page.dart';

import 'first_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  final List<Widget> _widgetList = <Widget>[
    FirstPage(),
    MessagePage(),
    Text('3'),
    Text('4'),
  ];

  void _onItemTap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          )
        ],
        onTap: _onItemTap,
      ),
      body: _widgetList.elementAt(_index),
      drawer: Drawer(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     typed = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) {
      //           return AddPage();
      //         },
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.green,
      // ),
    );
  }
}
