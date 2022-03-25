import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'account/account.dart';
import 'bookings/reservations.dart';
import 'explore/explore.dart';

class HomePage extends StatefulWidget {
  var username;
  var status;
  var account_type;
  var user_id;

  HomePage({required this.username, required this.status, required this.account_type, required this.user_id});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _initialIndex = 0;

  //on back click

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      ExplorePage(),
      Reservations(user_id: widget.user_id,),
      Account(username: widget.username, status: widget.status, account_type: widget.account_type, user_id: widget.user_id,)
    ];

    return Scaffold(
        body: _screens[_initialIndex],
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _initialIndex,
          showElevation: false, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _initialIndex = index;
          }),
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.explore_outlined),
              title: const Text('Explore'),
              activeColor: Colors.blueAccent,
            ),
            BottomNavyBarItem(
                icon: const Icon(Icons.list_alt_sharp),
                title: const Text('Reservations'),
                activeColor: Colors.blueAccent
            ),
            BottomNavyBarItem(
                icon: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                activeColor: Colors.blueAccent
            ),
          ],
        ),
    );
  }
}
