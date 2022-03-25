import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/bookings/tenant_agreement.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VaildationCode extends StatefulWidget {
  final String user_id;
  final String property_id;
  final String booking_id;

  VaildationCode({required this.user_id, required this.property_id, required this.booking_id});
  @override
  _VaildationCodeState createState() => _VaildationCodeState();
}

class _VaildationCodeState extends State<VaildationCode> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController verification_content = new TextEditingController();

  late SharedPreferences sharedPreferences;
  bool isLoading = false;
  String msg = '';

  verifyCode() async {
    Map data = {
      "user_id": widget.user_id,
      "property_id": widget.property_id,
      "payment_code": verification_content.text
    };
    final response = await http.post(Uri.parse(RemoteConnections.VERIFY_CODE_URL), body: data);
    print(response.body);
    var verify = null;
    verify = jsonDecode(response.body);

    if(verify["status"] == 'SUCCESS'){
      setState(() {
        isLoading = false;
        //msg = verify['message'];
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TenantAgreement(
                  heading_1: verify['agreement']['heading_1'],
                  heading_2: verify['agreement']['heading_2'],
                  heading_3: verify['agreement']['heading_3'],
                  section_1_heading: verify['agreement']['section_1_heading'],
                  section_1: verify['agreement']['section_1'],
                  section_2_heading: verify['agreement']['section_2_heading'],
                  section_2: verify['agreement']['section_2'],
                  section_3_heading: verify['agreement']['section_3_heading'],
                  section_3: verify['agreement']['section_3'],
                  section_4_heading: verify['agreement']['section_4_heading'],
                  section_4: verify['agreement']['section_4'],
                  section_5_heading: verify['agreement']['section_5_heading'],
                  section_5: verify['agreement']['section_5'],
                  section_6_heading: verify['agreement']['section_6_heading'],
                  section_6: verify['agreement']['section_6'],
                  section_7_heading: verify['agreement']['section_7_heading'],
                  section_7: verify['agreement']['section_7'],
                  section_8_heading: verify['agreement']['section_8_heading'],
                  section_8: verify['agreement']['section_8'],
                  property_id: widget.property_id,
                  booking_id: widget.booking_id,
                  rent: verify['invoice']['rent'],
                  security: verify['invoice']['security'],
                  total: verify['invoice']['total'],
                )
            )
        );
      });
    }
    else if(verify["status"] == 'Failed'){
      setState(() {
        isLoading = false;
        msg = verify['message'];
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Column(
                children: [
                  Text('Verification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                  Divider(),
                  Text(msg, style: TextStyle(fontSize: 16,),)
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('Alright', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                    onPressed: () => Navigator.pop(context, false)
                )
              ],
            )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      //color: Color(0xff01A0C7),
      color: Colors.blueAccent.withOpacity(0.9),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(verification_content.text == ""){
            setState(() {
              msg = "Code is required";
            });
          }
          else{
            setState(() {
              isLoading = true;
            });
            verifyCode();
          }
        },
        child: Text("Verfy",
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
        title: const Text("Verify Payments"),
      ),
      body: isLoading ? const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      )) : ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(""),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 0, right: 20, bottom: 8),
            child: Text("Enter code sent to your phone number for verification.", style: TextStyle(fontSize: 17),),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20, bottom: 5),
            child: Container(height: 35, child: TextField(
              obscureText: false,
              style: style,
              keyboardType: TextInputType.number,
              controller: verification_content,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  hintText: '00000',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
            ),),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 52,
                  width: 200,
                  //color: Colors.blueGrey,
                  child: submitButton,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
