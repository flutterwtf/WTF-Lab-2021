import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class MessagePage extends StatelessWidget {
  final List<String> entries = <String>['Hello i"m Amirlan', 'NOTdksapdpas'];
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.green,
            title: Text('Message'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.book),
              )
            ],
          )
        ],
        body: ListView.builder(
            itemBuilder: (context, index) {
              return ChatBubble(
                clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 20),
                backGroundColor: Colors.green.shade200,
                child: Text(entries[index]),
              );
            },
            itemCount: entries.length),
      ),
      bottomSheet: Container(
        height: 40.0,
        margin: EdgeInsets.all(10.0),
        child: TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Write something',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
