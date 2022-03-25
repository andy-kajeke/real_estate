import 'package:birungi_estates/components/home/bookings/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class TenantAgreement extends StatefulWidget {
  String heading_1;
  String heading_2;
  String heading_3;
  String section_1_heading;
  String section_1;
  String section_2_heading;
  String section_2;
  String section_3_heading;
  String section_3;
  String section_4_heading;
  String section_4;
  String section_5_heading;
  String section_5;
  String section_6_heading;
  String section_6;
  String section_7_heading;
  String section_7;
  String section_8_heading;
  String section_8;
  String property_id;
  String booking_id;
  String rent;
  String security;
  String total;

  TenantAgreement({required this.heading_1,required this.heading_2,required this.heading_3,required this.section_1_heading,required this.section_1,required this.section_2_heading,required this.section_2,required this.section_3_heading,required this.section_3,
  required this.section_4_heading,required this.section_4,required this.section_5_heading,required this.section_5,required this.section_6_heading,required this.section_6,required this.section_7_heading,required this.section_7,required this.section_8_heading,
  required this.section_8, required this.property_id,required this.booking_id, required this.rent, required this.security, required this.total});
  @override
  _TenantAgreementState createState() => _TenantAgreementState();
}

class _TenantAgreementState extends State<TenantAgreement> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Agreement"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:8.0, right: 8.0),
                  child: Text(widget.heading_1, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 4,),
                Padding(
                  padding: const EdgeInsets.only(left:8.0, right: 8.0),
                  child: Text(widget.heading_2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 4,),
                Padding(
                  padding: const EdgeInsets.only(left:8.0, right: 8.0),
                  child: Text(widget.heading_3, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Section (1): ' + widget.section_1_heading, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Text(widget.section_1, style: TextStyle(fontSize: 16,),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Section (2): ' + widget.section_2_heading, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Text(widget.section_2, style: TextStyle(fontSize: 16,),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Section (3): ' + widget.section_3_heading, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Text(widget.section_3, style: TextStyle(fontSize: 16,),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Section (4): ' + widget.section_4_heading, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Text(widget.section_4, style: TextStyle(fontSize: 16,),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Section (5): ' + widget.section_5_heading, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Text(widget.section_5, style: TextStyle(fontSize: 16,),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Section (6): ' + widget.section_6_heading, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Text(widget.section_6, style: TextStyle(fontSize: 16,),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Section (7): ' + widget.section_7_heading, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Text(widget.section_7, style: TextStyle(fontSize: 16,),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Section (8): ' + widget.section_8_heading, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Text(widget.section_8, style: TextStyle(fontSize: 16,),),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.blueAccent,
        height: 75,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              //=======Type button functions==============
              Expanded(
                child: InkWell(
                  onTap: () async {
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
                    //addToCart();
                  },
                  child: Container(
                    color: Colors.white,
                    height: 50,
                    child: Center(
                      child: Text('Decline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) => PaymentMethod(
                              property_id: widget.property_id,
                              booking_id: widget.booking_id,
                              rent: widget.rent,
                              security: widget.security,
                              total: widget.total,
                            )
                        )
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    height: 50,
                    child: Center(
                      child: Text('I Agree', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
