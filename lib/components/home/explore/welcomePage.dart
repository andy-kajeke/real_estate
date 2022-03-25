import 'package:birungi_estates/components/home/explore/explore.dart';
import 'package:birungi_estates/components/home/filters/categories.dart';
import 'package:flutter/material.dart';

import 'horizontal_filters.dart';
import 'notifications.dart';

class WelcomePage extends StatefulWidget {

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(AppBar().preferredSize.height),
      body: Column(
        children: [
          HorizontalFiltersExplore(),
          SizedBox(height: 5,),
          Expanded(
              child: ExplorePage(),
          )
        ],
      ),
    );
  }

  _appBar(height) => PreferredSize(
    preferredSize:  Size(MediaQuery.of(context).size.width, height+80 ),
    child: Stack(
      children: <Widget>[
        Container(     // Background
          child: Center(
            child: Text("Birungi Estates", style: TextStyle(fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),),),
          color:Theme.of(context).primaryColor,
          height: height+75,
          width: MediaQuery.of(context).size.width,
        ),

        Container(),   // Required some widget in between to float AppBar

        Positioned(    // To take AppBar Size only
          top: 100.0,
          left: 20.0,
          right: 20.0,
          child: AppBar(
            backgroundColor: Colors.white,
            leading: Icon(Icons.search, color: Theme.of(context).primaryColor,),
            primary: false,
            title: TextField(
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey)
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                // setState(() {
                //   facilityForDisplay = facility.where((data) {
                //     var title = data.property_title.toLowerCase();
                //     var location = data.address.toLowerCase();
                //     return title.contains(text);
                //   }).toList();
                // });
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Categories(
                      )));
                },),
              IconButton(
                icon: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Notifications(
                      )));
                },)
            ],
          ),
        )

      ],
    ),
  );
}
