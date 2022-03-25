import 'package:flutter/material.dart';

class NotifyMessage extends StatefulWidget {
  final String title;
  final String message;

  NotifyMessage({required this.title, required this.message});
  @override
  _NotifyMessageState createState() => _NotifyMessageState();
}

class _NotifyMessageState extends State<NotifyMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Details"),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Subject", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 0, right: 15.0, bottom: 0),
                child: Text(widget.title, style: TextStyle(fontSize: 16),),
              ),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Message", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 0, right: 15.0, bottom: 0),
                child: Text(widget.message, style: TextStyle(fontSize: 16),),
              ),
            ],
          )
        ],
      ),
    );
  }
}
