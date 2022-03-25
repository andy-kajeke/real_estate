import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/bookings/payment_verification.dart';
import 'package:birungi_estates/components/models/notification_model.dart';
import 'package:birungi_estates/components/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethod extends StatefulWidget {
  final String property_id;
  final String booking_id;
  final String rent;
  final String security;
  final String total;

  PaymentMethod({required this.property_id, required this.booking_id, required this.rent, required this.security, required this.total});
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController search = new TextEditingController();

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  var mathFunc = (Match match) => '${match[1]},';

  int listCount = 0;
  bool _isLoading = true;
  String msg = '';
  List<PaymentModel> method = [];
  List<PaymentModel> methodForDisplay = [];

  Future<List<PaymentModel>> getAllPaymentMethod() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id" : sharedPreferences.getString("user_id")
    };

    try {
      final response = await http.get(Uri.parse(RemoteConnections.GET_ALL_PAYMENT_METHODS_URL));
      //print(response.body);
      List<PaymentModel> markList = [];

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dataMethods = jsonData['data'] as List;
        //print(dataCategories);

        if(dataMethods != null){
          _isLoading = false;
        }
        else if(dataMethods == null ){
          _isLoading = false;
        }

        markList = dataMethods.map<PaymentModel>((json) => PaymentModel.fromJson(json)).toList();
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
    getAllPaymentMethod().then((value) {
      setState(() {
        method.addAll(value);
        methodForDisplay = method;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchCategory = Container(
      margin: EdgeInsets.only(left:10.0, top: 15.0, right: 10.0, bottom: 15.0),
      padding: EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 17.0),
        controller: search,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white,),
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.white)
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            methodForDisplay = method.where((data) {
              var name = data.name.toLowerCase();
              return name.contains(text);
            }).toList();
          });
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Payment Methods"),
      ),
      body: FutureBuilder(
          future: getAllPaymentMethod(),
          builder: (context, snapshot) {
            if(listCount == 0){
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )) : Center( child: Container(
                child: Text("There are no methods to show", style: TextStyle(fontSize: 16.0),),
              ));
            }else{
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )) : Column(
                children: [
                  Container(
                    height: 70,
                    child: Container(
                      color: Colors.blueAccent,
                      padding: EdgeInsets.only(left: 6.0, top: 0.0, right: 6.0, bottom: 0.0),
                      child: searchCategory,
                    ),
                  ),
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
      itemCount: methodForDisplay.length,
      itemBuilder: (context, index) {
        var method = methodForDisplay[index];
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
                                            child: Text('${method.name[0]}'.toUpperCase(),
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
                                Text('${method.name}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                // SizedBox(height: 2,),
                                // Text('Type: '+'${booking.booking_type}',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
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
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pay via '.toUpperCase() + '${method.name}'.toUpperCase(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue),),
                      Divider(),
                      SizedBox(height: 5,),
                      Text('${method.details}', style: TextStyle(fontSize: 16,),),
                      SizedBox(height: 5,),
                      Divider(),
                      Divider(),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('INVOICE', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text(widget.rent.replaceAllMapped(reg, mathFunc), style: TextStyle(fontSize: 16,),),
                      SizedBox(height: 15,),
                      Text(widget.security.replaceAllMapped(reg, mathFunc), style: TextStyle(fontSize: 16,),),
                      SizedBox(height: 15,),
                      Text(widget.total.replaceAllMapped(reg, mathFunc), style: TextStyle(fontSize: 16,),),
                      SizedBox(height: 5,),
                      Divider(),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Alright', style: TextStyle(fontSize: 17, color: Colors.blue, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    SizedBox(width: 40,),
                    FlatButton(
                        child: Text('Already Paid', style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => PaymentVerification(
                                paymentMethod: '${method.name}',
                                property_id: widget.property_id,
                                booking_id: widget.booking_id,
                                payment_id: method.id,
                              )));
                        }
                    )
                  ],
                )
            );
          },
        );
      },
    );
  }
}
