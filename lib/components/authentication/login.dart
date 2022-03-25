import 'dart:io';

import 'package:birungi_estates/components/authentication/signup.dart';
import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController email_content = TextEditingController();
  TextEditingController password_= TextEditingController();
  TextEditingController passwordNumber_content= TextEditingController();
  TextEditingController email2_content= TextEditingController();

  bool _isLoading = false;
  String msg = "";
  String msg2 = "";

  forgotMyPassword(String email) async {
    Map data = {
      'email' : email
    };

    try {
      var response = await http.post(Uri.parse(RemoteConnections.FORGOT_PASSWORD_URL), body: data);
      print(response.body);
      var sms = null;

      if(response.statusCode == 200) {
        sms = json.decode(response.body);
        setState(() {
          if(sms['message'] == "Email sent"){
            // Navigator.of(context).push(
            //     new MaterialPageRoute(
            //         builder: (context) => ResetPassword(
            //           email: email,
            //         )
            //     )
            // );
          }
          else{
            setState(() {
              msg2 = sms['message'];
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Container(
                          height: 155.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // ignore: avoid_init_to_null
                            children: <Widget>[
                              Text("SORRY!!...", style: TextStyle(color: Colors.red,fontSize: 17, fontWeight: FontWeight.bold),),
                              Divider(),
                              Text(msg2, style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),),
                              Divider(),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context, false);
                                        msg2 = "";
                                      },
                                      child: Card(
                                        color: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15.0, top: 6.0, right: 15.0, bottom: 4.0),
                                            child: Text("Close", style: TextStyle(color: Colors.white, fontSize: 16),),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    );
                  });
            });
          }
        });
      }
      else{}
    } on SocketException {
      throw msg = 'No Internet connection';
    }

  }

  signIn(String email, String password) async{
    Map data = {
      "email": email,
      "password": password
    };

    var response = await http.post(Uri.parse(RemoteConnections.LOGIN_URL), body: data);
    print(response.body);
    print("----HHHHH----------");
    var authenticate = null;
    authenticate = jsonDecode(response.body);
    //print('====='+authenticate['message']+'======');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(authenticate['status'] == 'Failed'){
      setState(() {
        _isLoading = false;
        msg = authenticate['message'];

        //print(authenticate['message']);
      });
    }else if(authenticate['data']['status'] == 'active') {
      setState(() {
        _isLoading = true;
        sharedPreferences.setBool("isLoggedIn", true);
        sharedPreferences.setString("username", authenticate["data"]["name"]);
        sharedPreferences.setString("status", authenticate["data"]["status"]);
        sharedPreferences.setString("account_type", authenticate["data"]["account_type"]);
        sharedPreferences.setString("user_id", authenticate["data"]["user_id"].toString());

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
      });
    }

  }

  @override
  void initState() {
    super.initState();
    // phoneNumber_content.text = '256';
    //passwordNumber_content.text = '256';
  }

  @override
  Widget build(BuildContext context) {
    final email = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.emailAddress,
      controller: email_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final email_2 = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.emailAddress,
      controller: email2_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintText: 'Enter Email Address'
      ),
    );

    final password = TextField(
      obscureText: true,
      style: style,
      controller: password_,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final forgotPassword = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.phone,
      controller: passwordNumber_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      //color: Color(0xff01A0C7),
      color: Colors.blueAccent.withOpacity(0.9),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(email_content.text == ""){
            setState(() {
              msg = "Email is required";
            });
          } else if(password_.text == ""){
            setState(() {
              msg = "Password is required";
            });
          }else{
            setState(() {
              _isLoading = true;
            });
            signIn(email_content.text, password_.text);
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
        body:Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 55.0),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'images/be.png',
                  width: 130,
                  height: 130,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text("Birungi Estates", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            //Text("Safe", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal),),
            SizedBox(height: 5,),
            Expanded(
                child: Stack(
                  children: <Widget> [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0)
                          )
                      ),
                      child: ListView(
                        children: [Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0, bottom: 20.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _isLoading ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(child: CircularProgressIndicator(),),
                              ) : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(msg, style: TextStyle(color: Colors.red),),
                                  ),
                                  Row(
                                    children: [
                                      Text("Enter Email", style: TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Container(height: 40.0,child: email),
                                  SizedBox(height: 20.0,),
                                  Row(
                                    children: [
                                      Text("Password", style: TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Container(height: 40.0,child: password),
                                  SizedBox(height: 20.0,),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 0.0),
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.end,
                                  //     children: <Widget>[
                                  //       InkWell(
                                  //         onTap: () => {
                                  //           showGeneralDialog(
                                  //               barrierLabel: "Label",
                                  //               barrierDismissible: true,
                                  //               barrierColor: Colors.black.withOpacity(0.5),
                                  //               transitionDuration: Duration(milliseconds: 700),
                                  //               context: context,
                                  //               pageBuilder: (context, anim1, anim2) {
                                  //                 return ListView(
                                  //                   children: [
                                  //                     Align(
                                  //                       alignment: Alignment.bottomCenter,
                                  //                       child: Container(
                                  //                         height: 240,
                                  //                         child: SizedBox.expand(child: Card(
                                  //                           color: Colors.white,
                                  //                           shape: RoundedRectangleBorder(
                                  //                             borderRadius: BorderRadius.circular(25),
                                  //                           ),
                                  //                           child: Padding(
                                  //                             padding: const EdgeInsets.all(8.0),
                                  //                             child: Material(
                                  //                               child: Column(
                                  //                                 crossAxisAlignment: CrossAxisAlignment.center,
                                  //                                 children: [
                                  //                                   Padding(
                                  //                                     padding: const EdgeInsets.all(8.0),
                                  //                                     child: Text("Forgot Password?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  //                                   ),
                                  //                                   Divider(),
                                  //                                   Padding(
                                  //                                     padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
                                  //                                     child: Container(height: 40,child: email_2),
                                  //                                   ),
                                  //                                   SizedBox(height: 20,),
                                  //                                   Row(
                                  //                                     children: [
                                  //                                       Expanded(
                                  //                                         child: InkWell(
                                  //                                           onTap: (){
                                  //                                             Navigator.pop(context, false);
                                  //                                           },
                                  //                                           child: Padding(
                                  //                                             padding: const EdgeInsets.only(left: 15.0, bottom: 0.0),
                                  //                                             child: Card(
                                  //                                               color: Colors.blueAccent.withOpacity(0.9),
                                  //                                               shape: RoundedRectangleBorder(
                                  //                                                 borderRadius: BorderRadius.circular(20),
                                  //                                               ),
                                  //                                               child: Container(
                                  //                                                 height: 35,
                                  //                                                 child: Padding(
                                  //                                                   padding: const EdgeInsets.all(8.0),
                                  //                                                   child: Center(child: Text("Close", style: TextStyle(color: Colors.white),)),
                                  //                                                 ),
                                  //                                               ),
                                  //                                             ),
                                  //                                           ),
                                  //                                         ),
                                  //                                       ),
                                  //                                       Expanded(
                                  //                                         child: InkWell(
                                  //                                           onTap: (){
                                  //                                             forgotMyPassword(email2_content.text);
                                  //                                           },
                                  //                                           child: Padding(
                                  //                                             padding: const EdgeInsets.only(right: 15.0, bottom: 0.0),
                                  //                                             child: Card(
                                  //                                               color: Colors.blueAccent.withOpacity(0.9),
                                  //                                               shape: RoundedRectangleBorder(
                                  //                                                 borderRadius: BorderRadius.circular(20),
                                  //                                               ),
                                  //                                               child: Container(
                                  //                                                 height: 35,
                                  //                                                 child: Padding(
                                  //                                                   padding: const EdgeInsets.all(8.0),
                                  //                                                   child: Center(child: Text("Send Mail", style: TextStyle(color: Colors.white),)),
                                  //                                                 ),
                                  //                                               ),
                                  //                                             ),
                                  //                                           ),
                                  //                                         ),
                                  //                                       ),
                                  //                                     ],
                                  //                                   ),
                                  //                                   Padding(
                                  //                                     padding: const EdgeInsets.only(left: 8.0, top: 10),
                                  //                                     child: Text(msg2, style: TextStyle(color: Colors.red, fontSize: 16),),
                                  //                                   ),
                                  //                                 ],
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //                         )),
                                  //                         margin: EdgeInsets.only(bottom: 0.0, left: 0.0, right: 0.0),
                                  //                         decoration: BoxDecoration(
                                  //                           color: Colors.blueAccent.withOpacity(0.9),
                                  //                           borderRadius: BorderRadius.only(
                                  //                               topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 );
                                  //               }
                                  //           )
                                  //         },
                                  //         child: Text(
                                  //           'Forgot password?',
                                  //           style: TextStyle(
                                  //               fontSize: 16,
                                  //               color: Colors.blueAccent,
                                  //               fontStyle: FontStyle.italic),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 52,
                                          width: 200,
                                          //color: Colors.blueGrey,
                                          child: loginButton,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 0.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () => {
                                            Navigator.of(context).push(new MaterialPageRoute(
                                                builder: (context) => Signup()
                                            ))
                                          },
                                          child: Text(
                                            'Have no account?.. Register',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0,)
                                ],
                              ),
                            ),
                          ),
                        )],
                      ),
                    )
                  ],
                )
            )
          ],
        )
    );
  }
}
