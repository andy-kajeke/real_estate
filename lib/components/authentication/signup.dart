import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}
class _SignupState extends State<Signup> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController firstname_content = new TextEditingController();
  TextEditingController surname_content = new TextEditingController();
  TextEditingController email_content = new TextEditingController();
  TextEditingController phoneNumber_content = new TextEditingController();
  TextEditingController password_content = new TextEditingController();
  TextEditingController confirmPassword_content = new TextEditingController();

  String msg = "";
  String msg2 = "";
  bool _isLoading = false;

  signUp(String name, String email, String phone, String password, String passwordConfirm, String accountType, String districtID) async {
    Map data = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "password_confirm": passwordConfirm,
      "acc_type": accountType,
      "district_id": districtID
    };
    var response = await http.post(Uri.parse(RemoteConnections.CREATE_ACCOUNT_URL), body: data);
    print(data);
    print('=========================================');
    print(response.body);
    var createAccount = null;
    createAccount = jsonDecode(response.body);
    //print('======='+ createAccount['errors']['error']+'=========');

    if (createAccount['status'] == "Failed") {
      setState(() {
        _isLoading = false;
        msg = createAccount['errors']['error'];
      });
    }
    if(createAccount['message'] == 'User Created Successfully') {
      setState(() {
        _isLoading = false;
        print(createAccount['message']);
        msg2 = 'Hello ' + createAccount['user']['name'] + ', \nWelcome to BIRUNGI ESTATES your account has been created successfully.';

        firstname_content.text = "";
        surname_content.text = "";
        email_content.text = "";
        phoneNumber_content.text = "";
        password_content.text = "";
        confirmPassword_content.text = "";

        showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                  title: Column(
                    children: [
                      Text("Account Confirmation"),
                      Divider()
                    ],
                  ),
                  content: Container(
                    height: 120.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: avoid_init_to_null
                      children: <Widget>[
                        Text(msg2,style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: FlatButton(
                          child:
                          Text('Alright', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                                  (Route<dynamic> route) => false,
                            );
                          }),
                    ),
                  ]);
            });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumber_content.text = "256";
  }

  @override
  Widget build(BuildContext context) {
    final firstName = TextField(
      obscureText: false,
      style: style,
      controller: firstname_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final surname = TextField(
      obscureText: false,
      style: style,
      controller: surname_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final emailAddress = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.emailAddress,
      controller: email_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final phoneNumber = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.phone,
      controller: phoneNumber_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final password = TextField(
      obscureText: true,
      style: style,
      keyboardType: TextInputType.visiblePassword,
      controller: password_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final confirmPassword = TextField(
      obscureText: true,
      style: style,
      keyboardType: TextInputType.visiblePassword,
      controller: confirmPassword_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      //color: Color(0xff01A0C7),
      color: Colors.blueAccent.withOpacity(0.9),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (firstname_content.text == "") {
            setState(() {
              msg = "First name is required";
            });
          } else if (surname_content.text == "") {
            setState(() {
              msg = "Surname is required";
            });
          } else if (email_content.text == "") {
            setState(() {
              msg = "Email is required";
            });
          }else if (phoneNumber_content.text == "") {
            setState(() {
              msg = "Phone number is required";
            });
          } else if (password_content.text == "") {
            setState(() {
              msg = "Password is required";
            });
          } else if (confirmPassword_content.text == "") {
            setState(() {
              msg = "Confirm password is required";
            });
          } else if (password_content.text != confirmPassword_content.text) {
            setState(() {
              msg = "Password doesn't match";
            });
          } else {
            setState(() {
              _isLoading = true;
            });
            String user = firstname_content.text + " " + surname_content.text;

            signUp(user, email_content.text, phoneNumber_content.text, password_content.text, confirmPassword_content.text, "client", "1");
          }
        },
        child: Text("Create Account",
            textAlign: TextAlign.center,
            style: style.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Create Account"),
        ),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 20.0, right: 10.0, bottom: 10.0),
              child: Center(
                child: Container(
                  //color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                            right: 10.0,
                            bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("First Name",
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              child: firstName,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 5.0,
                            right: 10.0,
                            bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Surname",
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              child: surname,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 5.0,
                            right: 10.0,
                            bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Email",
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              child: emailAddress,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 5.0,
                            right: 10.0,
                            bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Phone number",
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              child: phoneNumber,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 5.0,
                            right: 10.0,
                            bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Password",
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              child: password,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 5.0,
                            right: 10.0,
                            bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Confirm password",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              child: confirmPassword,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          msg,
                          style: TextStyle(color: Colors.red,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 52,
                    width: 200,
                    //color: Colors.blueGrey,
                    child: signUpButton,
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}
