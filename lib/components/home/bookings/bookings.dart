import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/bookings/payment_verification.dart';
import 'package:birungi_estates/components/home/bookings/vaildation_code.dart';
import 'package:birungi_estates/components/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Bookings extends StatefulWidget {
  final String user_id;

  Bookings({required this.user_id});
  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController verification_content = TextEditingController();

  int listCount = 0;
  bool _isLoading = true;
  String msg = '';
  List<BookingModel> booking = [];
  List<BookingModel> bookingForDisplay = [];

  Future<List<BookingModel>> getAllBookings() async {
    Map data = {
      "user_id": widget.user_id
    };
    try {
      final response = await http.post(Uri.parse(RemoteConnections.GET_BOOKINGS_URL), body: data);
      //print(response.body);
      List<BookingModel> markList = [];

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dataBookings = jsonData['data'] as List;
        //print(dataBookings);

        if(dataBookings != null){
          _isLoading = false;
        }
        else if(dataBookings == null ){
          _isLoading = false;
        }

        markList = dataBookings.map<BookingModel>((json) => BookingModel.fromJson(json)).toList();
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
        booking.addAll(value);
        bookingForDisplay = booking;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getAllBookings(),
          builder: (context, snapshot) {
            if(listCount == 0){
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )) : Center( child: Container(
                child: Text("There are no inspection requests to show", style: TextStyle(fontSize: 16.0),),
              ));
            }else{
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )) : Column(
                children: [
                  // Container(
                  //   height: 70,
                  //   child: Container(
                  //     color: Colors.redAccent,
                  //     padding: EdgeInsets.only(left: 6.0, top: 0.0, right: 6.0, bottom: 0.0),
                  //     child: searchCategory,
                  //   ),
                  // ),
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
      itemCount: bookingForDisplay.length,
      itemBuilder: (context, index) {
        var booking = bookingForDisplay[index];
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
                                  height: 50,
                                  decoration: BoxDecoration(
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
                                            child: Text('B',
                                                style: TextStyle(
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
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ref: '+'${booking.booking_ref}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                SizedBox(height: 2,),
                                Text('Type: '+'${booking.booking_type}',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
                                SizedBox(height: 2,),
                                Text('Status: '+ '${booking.status}',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16,),),
                                SizedBox(height: 2,),
                                Text('${booking.created_at}',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.red),),
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
            if('${booking.status}' == 'pending_payment'){
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context) => VaildationCode(
                        user_id: widget.user_id,
                        property_id: '${booking.property_id}'.toString(),
                        booking_id: '${booking.booking_id}'.toString(),
                      )
                  )
              );
            }
            else if ('${booking.status}' == 'pending_inspection'){
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Column(
                      children: [
                        Text('Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                        Divider(),
                        Text("Dear valuable client, your inspection process for this property is still pending.\n\nFor any inquiries contact the support center. Thank you.", style: TextStyle(fontSize: 16,),)
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('Alright', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                          onPressed: () =>Navigator.pop(context, false),
                      )
                    ],
                  )
              );
            }
            else if ('${booking.status}' == 'processing'){
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Column(
                      children: [
                        Text('Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                        Divider(),
                        Text("Dear valuable client, your payment details where submitted successfully...\n\nFor any inquiries contact the support center. Thank you.", style: TextStyle(fontSize: 16,),)
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Alright', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                        onPressed: () =>Navigator.pop(context, false),
                      )
                    ],
                  )
              );
            }
            else if ('${booking.status}' == 'processed'){
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Column(
                      children: [
                        Text('Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                        Divider(),
                        Text("Dear valuable client, your payment details where approved successfully...\nFor any inquiries contact the support center. Thank you.", style: TextStyle(fontSize: 16,),)
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Alright', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                        onPressed: () =>Navigator.pop(context, false),
                      )
                    ],
                  )
              );
            }
            else{}
          },
        );
      },
    );
  }
}
