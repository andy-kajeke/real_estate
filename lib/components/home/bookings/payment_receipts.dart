import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/bookings/receipt.dart';
import 'package:birungi_estates/components/models/receipt_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentReceipts extends StatefulWidget {
  @override
  _PaymentReceiptsState createState() => _PaymentReceiptsState();
}

class _PaymentReceiptsState extends State<PaymentReceipts> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController search = new TextEditingController();

  int listCount = 0;
  bool _isLoading = true;
  String msg = '';
  List<ReceiptModel> notification = [];
  List<ReceiptModel> notificationForDisplay = [];

  Future<List<ReceiptModel>> getAllBookings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id" : sharedPreferences.getString("user_id")
    };

    try {
      final response = await http.post(Uri.parse(RemoteConnections.PAY_RECEIPTS_URL), body: data);
      //print(response.body);
      List<ReceiptModel> markList = [];

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dataReceipts = jsonData['data'] as List;
        //print(dataCategories);

        if(dataReceipts != null){
          _isLoading = false;
        }
        else if(dataReceipts == null ){
          _isLoading = false;
        }

        markList = dataReceipts.map<ReceiptModel>((json) => ReceiptModel.fromJson(json)).toList();
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
        notification.addAll(value);
        notificationForDisplay = notification;
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
                child: Text("There are no receipts to show", style: TextStyle(fontSize: 16.0),),
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
                  //     color: Colors.blueAccent,
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
      itemCount: notificationForDisplay.length,
      itemBuilder: (context, index) {
        var notification = notificationForDisplay[index];
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
                                            child: Text('PR'.toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22.0,
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
                                Text('REF: '+'${notification.payment_ref}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                SizedBox(height: 2,),
                                Text('Status: '+ '${notification.status}',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16,),),
                                SizedBox(height: 2,),
                                Text('${notification.created_at}',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.red),),
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
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => Receipt(
                  property_ref: '${notification.property_ref}',
                  property_title: '${notification.property_title}',
                  payment_ref: '${notification.payment_ref}',
                  payment_mode: '${notification.payment_mode}',
                  booking_ref: '${notification.booking_ref}',
                  transaction_id: '${notification.transaction_id}',
                  amount: '${notification.amount}'.toString(),
                  status: '${notification.status}',
                  created_at: '${notification.created_at}',
                )));
          },
        );
      },
    );
  }
}