import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'components/authentication/login.dart';
import 'components/home/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //SharedPreferences sharedPreferences;

  String msg = "";
  checkPersonalLoginStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        if(sharedPreferences.getBool('isLoggedIn') ?? false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage(
              username: sharedPreferences.getString("username"),
              status: sharedPreferences.getString("status"),
              account_type: sharedPreferences.getString("account_type"),
              user_id: sharedPreferences.getString("user_id"),
            )),
                (Route<dynamic> route) => false,
          );
        }
        else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
                (Route<dynamic> route) => false,
          );
        }
      });
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        if(sharedPreferences.getBool('isLoggedIn') ?? false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage(
              username: sharedPreferences.getString("username"),
              status: sharedPreferences.getString("status"),
              account_type: sharedPreferences.getString("account_type"),
              user_id: sharedPreferences.getString("user_id"),
            )),
                (Route<dynamic> route) => false,
          );
        }
        else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
                (Route<dynamic> route) => false,
          );
        }
      });
      // I am connected to a wifi network.
    }
    else{
      msg = "No Internet Connection";
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Container(
                  color: Colors.blueAccent.withOpacity(0.9),
                  height: 130.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // ignore: avoid_init_to_null
                    children: <Widget>[
                      Image.asset(
                        'images/internet.png',
                        width: 60,
                        height: 60,
                      ),
                      Center(child: Text(msg,style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white))),
                      const SizedBox(height: 20.0,),
                      InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new SplashScreen()
                                )
                            );
                          },
                          child: const Center(
                              child: Text("Try Again",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                          )
                      ),
                    ],
                  ),
                )
            );
          }
      );
    }
  }

  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 4),
            () => {checkPersonalLoginStatus()}
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent.withOpacity(0.9),
      child: Center(
        child: Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'images/be.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}

