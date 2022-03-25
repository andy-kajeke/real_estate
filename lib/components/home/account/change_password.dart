import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPassword_content = new TextEditingController();
  TextEditingController newPassword_content = new TextEditingController();

  String msg = "";
  bool _isLoading = false;

  changePassword() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id" : sharedPreferences.getString("user_id"),
      "old_password":currentPassword_content.text,
      "password" : newPassword_content.text,
      "password_confirm" : newPassword_content.text
    };

    try {
      var response = await http.post(Uri.parse(RemoteConnections.CHANGE_PASSWORD_URL), body: data);
      var change = null;
      print(response.body);

      if(response.statusCode == 200){
        change = json.decode(response.body);
        setState(() {
          // _isLoading = true;
          msg = change["message"];
          print(change["message"]);
        });
      }
      else{
        msg = "Internet connection failed..!! Check connectivity and try again";
      }
    } on SocketException {
      throw msg = 'No Internet connection';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPassword = Container(
      height: 40,
      margin: EdgeInsets.only(left:10.0, top: 10.0, right: 10.0, bottom: 10.0),
      padding: EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        style: TextStyle(color: Colors.black, fontSize: 18.0,),
        controller: currentPassword_content,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Enter Current Password',
            hintStyle: TextStyle(color: Colors.black54, fontSize: 17)
        ),
      ),
    );

    final newPassword = Container(
      height: 40,
      margin: EdgeInsets.only(left:10.0, top: 10.0, right: 10.0, bottom: 10.0),
      padding: EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        style: TextStyle(color: Colors.black, fontSize: 18.0,),
        controller: newPassword_content,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Enter New Password',
            hintStyle: TextStyle(color: Colors.black54, fontSize: 17)
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Change Account Password"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text("Current Password", style: TextStyle(color: Colors.black, fontSize: 17),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, top: 2.0),
            child: Container(
              height: 65,
              child: currentPassword,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0),
            child: Text("New Password", style: TextStyle(color: Colors.black, fontSize: 17),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, top: 2.0),
            child: Container(
              height: 65,
              child: newPassword,
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 1.0),
            child: _isLoading ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator(),),
            ) : Center(child: Text(msg, style: TextStyle(color: Colors.red, fontSize: 16),)),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.blueAccent,
        child: InkWell(
          onTap: (){
            changePassword();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0,top: 5.0, right: 40.0, bottom: 5.0),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Change Password", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
