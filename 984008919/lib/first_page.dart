import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_chat_journal/add_page.dart';
import 'question_button.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late String typed;

  final List<String> items =
      List<String>.generate(20, (index) => 'Items$index');

  final List item = [];

  void deleteItem(int index) {
    item.removeAt(index);
  }

  void copyItem(int index) {
    FlutterClipboard.copy(item[index]);
  }

  void editItem(int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.green,
            title: const Text('Home'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.nightlight_round),
              ),
            ],
          )
        ],
        body: Column(
          children: <Widget>[
            QuestionnareButton(),
            item.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      itemCount: item.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10.0),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 200,
                                    child: Column(
                                      children: <Widget>[
                                        InkWell(
                                          child: Container(
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                            width: double.infinity,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              copyItem(index);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                        SizedBox(height: 10.0),
                                        InkWell(
                                          child: Container(
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                            width: double.infinity,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              deleteItem(index);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                        SizedBox(height: 10.0),
                                        InkWell(
                                          child: Container(
                                            child: Text(
                                              'Copy',
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                            width: double.infinity,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              copyItem(index);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: ListTile(
                            title: Text(item[index]),
                          ),
                        );
                      },
                    ),
                  )
                : Card(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: const Text(
                            'Welcome to Amirlan Journal',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.all(10.0),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: const Text(
                            'Make Amirlan Great Again',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          typed = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddPage();
              },
            ),
          );
          if (typed == null) {
            return;
          }
          setState(() {
            item.add(typed);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
