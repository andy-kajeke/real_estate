import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'notify_message.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController search = TextEditingController();
  late SharedPreferences sharedPreferences;

  int listCount = 0;
  bool _isLoading = true;
  String msg = '';
  List<NotificationModel> notification = [];
  List<NotificationModel> notificationForDisplay = [];

  Future<List<NotificationModel>> getAllBookings() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id" : sharedPreferences.getString("user_id")
    };

    try {
      final response = await http.post(Uri.parse(RemoteConnections.NOTIFICATION_URL), body: data);
      //print(response.body);
      List<NotificationModel> markList = [];

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dataNotification = jsonData['data'] as List;
        //print(dataCategories);

        if(dataNotification != null){
          _isLoading = false;
        }
        else if(dataNotification == null ){
          _isLoading = false;
        }

        markList = dataNotification.map<NotificationModel>((json) => NotificationModel.fromJson(json)).toList();
      }

      //print("========Size=============");
      setState(() {
        listCount = markList.length;
      });
      //print("List Size: $listCount");
      return markList;
    } on SocketException {
      throw msg = 'No Internet connection';
    }
  }

  @override
  void initState() {
    super.initState();
    getAllBookings().then((value) {
      setState(() {
        notification.addAll(value);
        notificationForDisplay = notification;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchCategory = Container(
      margin: EdgeInsets.only(left:10.0, top: 15.0, right: 10.0, bottom: 15.0),
      padding: EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 17.0),
        controller: search,
        decoration: const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white,),
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.white)
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            notificationForDisplay = notification.where((data) {
              var name = data.title.toLowerCase();
              return name.contains(text);
            }).toList();
          });
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Notifications"),
      ),
      body: FutureBuilder(
          future: getAllBookings(),
          builder: (context, snapshot) {
            if(listCount == 0){
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )) : Center( child: Container(
                child: Text("There are no notifications to show", style: TextStyle(fontSize: 16.0),),
              ));
            }else{
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )) : Column(
                children: [
                  Container(
                    height: 70,
                    child: Container(
                      color: Colors.blueAccent,
                      padding: EdgeInsets.only(left: 6.0, top: 0.0, right: 6.0, bottom: 0.0),
                      child: searchCategory,
                    ),
                  ),
                  Expanded(
                      child: _buildListView(snapshot.data)),
                ],
              );
            }
          }
      ),
    );
  }

  ListView _buildListView(index) {
    return ListView.builder(
      itemCount: notificationForDisplay.length,
      itemBuilder: (context, index) {
        var notification = notificationForDisplay[index];
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2.0,
            ),
            child: Card(
              elevation: 1.0,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                            child: Text(notification.title[0].toUpperCase(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25.0,
                                                    color: Colors.white)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${notification.title}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                // SizedBox(height: 2,),
                                // Text('Type: '+'${booking.booking_type}',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () async {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => NotifyMessage(
                  title: '${notification.title}',
                  message: '${notification.message}',
                )));
          },
        );
      },
    );
  }
}
