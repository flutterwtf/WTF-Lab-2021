import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              const Text(
                'Create a new Page?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Name of the page',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, titleController.text);
                },
                child: Text('Add'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
