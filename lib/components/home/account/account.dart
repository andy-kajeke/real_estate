import 'dart:io';

import 'package:birungi_estates/components/authentication/login.dart';
import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/explore/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'change_password.dart';

class Account extends StatefulWidget {
  final String username;
  final String status;
  final String account_type;
  final String user_id;

  Account({required this.username, required this.status, required this.account_type, required this.user_id});
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  String ownerPhoto = "https://services.data-intell.co.uk/keepkeep/user_photo/holder.png";

  ownerProfile() async {
    var response = await http.get(Uri.parse(RemoteConnections.USER_PROFILE_URL + widget.user_id));
    //print(response.body);
    var ownerInfo = null;

    if (response.statusCode == 200){
      ownerInfo = jsonDecode(response.body);
      setState(() {
        ownerPhoto = ownerInfo['clients']['user_image'];
        //print(ownerInfo['clients']['user_image']);
      });
    }
  }

  String Line = "";
  String msg = '';

  helpLine() async{
    Map data = {
      "name":"phone"
    };
    var response = await http.post(Uri.parse(RemoteConnections.CALL_CENTER_URL), body: data);
    print(response.body);
    var supportLine = null;

    try {
      if(response.statusCode == 200){
        supportLine = json.decode(response.body);
        setState(() {
          //_isLoading = true;
          Line = supportLine["data"]["value"];
          print(supportLine["data"]["value"]);
        });
      }
      else{
        Line = "256758309356";
      }
    } on SocketException {
      throw msg = 'No Internet connection';
    }
  }

  _launchCaller() async {
    var url = 'tel: ' + Line;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final Email feedback = Email(
    body: 'Feedback Message',
    subject: 'Birungi Estates Client Feedback',
    recipients: ['birungiinvestment@yahoo.com'],
    //cc: [''],
    isHTML: false,
  );


  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.commit();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    //ownerProfile();
    helpLine();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        title: Text("My Account"),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                color: Colors.blueAccent,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 80,
                          width: 80,
                          child: AspectRatio(
                            aspectRatio: 1/1,
                            child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  placeholder: "images/holder.png",
                                  image: '${ownerPhoto}'),
                            ),
                          )
                      ),
                    ),
                    SizedBox(width: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text(widget.username, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                          SizedBox(height: 4,),
                          //Text(widget.account_type, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("INBOX", style: TextStyle(fontSize: 16, color: Colors.grey[500]),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => Notifications(
                        )));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(
                            Icons.notifications,
                            color: Colors.blueAccent[700],
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text("Notifications", style: TextStyle(fontSize: 17,),),
                    ],
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("SUPPORT CENTER", style: TextStyle(fontSize: 16, color: Colors.grey[500]),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
                child: InkWell(
                  onTap: () {_launchCaller();},
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(
                            Icons.phone,
                            color: Colors.blueAccent[700],
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text("Call Help Line", style: TextStyle(fontSize: 17,),),
                    ],
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
                child: InkWell(
                  onTap: () async {
                    await FlutterEmailSender.send(feedback);
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(
                            Icons.chat,
                            color: Colors.blueAccent[700],
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text("Send Feedback", style: TextStyle(fontSize: 17,),),
                    ],
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ACCOUNT SETTING", style: TextStyle(fontSize: 16, color: Colors.grey[500]),),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.of(context).push(new MaterialPageRoute(
              //           builder: (context) => ChangePassword()
              //       ));
              //     },
              //     child: Row(
              //       children: [
              //         Container(
              //           height: 40,
              //           width: 40,
              //           decoration: BoxDecoration(
              //               color: Colors.blueAccent.withOpacity(0.1),
              //               shape: BoxShape.circle
              //           ),
              //           child: Center(
              //             child: Icon(
              //               Icons.account_box,
              //               color: Colors.blueAccent[700],
              //               size: 25,
              //             ),
              //           ),
              //         ),
              //         SizedBox(width: 15,),
              //         Text("Edit Profile", style: TextStyle(fontSize: 17,),)
              //       ],
              //     ),
              //   ),
              // ),
              // Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => ChangePassword()
                    ));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(
                            Icons.lock,
                            color: Colors.blueAccent[700],
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text("Change Password", style: TextStyle(fontSize: 17,),)
                    ],
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Do you really want to logout?...', style: TextStyle(fontSize: 16),),
                          actions: <Widget>[
                            FlatButton(
                              child: const Text('NO', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            FlatButton(
                              child: const Text('YES', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                              onPressed: () => checkLoginStatus(),
                            )
                          ],
                        )
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(
                            Icons.logout,
                            color: Colors.blueAccent[700],
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text("Logout", style: TextStyle(fontSize: 17,),)
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
