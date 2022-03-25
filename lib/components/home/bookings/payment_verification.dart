import 'dart:typed_data';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class PaymentVerification extends StatefulWidget {
  final String paymentMethod;
  final String property_id;
  final String booking_id;
  final int payment_id;

  PaymentVerification({required this.paymentMethod, required this.property_id, required this.booking_id, required this.payment_id});
  @override
  _PaymentVerificationState createState() => _PaymentVerificationState();
}

class _PaymentVerificationState extends State<PaymentVerification> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController paymentMode_content = TextEditingController();
  TextEditingController paymentRef_content= TextEditingController();

  bool isLoading = false;
  String msg = '';
  String msg2 = '';

  Dio dio = Dio();
  late MultipartFile image1;

  List<Asset> images = <Asset>[];
  String _error = 'No Error Detected';

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      crossAxisSpacing: 1,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 150,
          height: 150,
        );
      }),
    );
  }
  /////////////////////////////////////////////////select photos//////////////////////////////////////////////////
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#0000ff",
          actionBarTitle: "Select Receipt Photo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  paymentProof() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(images.length != null){
      ByteData byteData1 = await images[0].getByteData();
      List<int> image1Data = byteData1.buffer.asUint8List();
      image1 = MultipartFile.fromBytes(image1Data, filename: images[0].name, contentType: MediaType('image', 'jpg',));

      print(images[0].name);

      FormData formData = FormData.fromMap({
        "user_id": sharedPreferences.getString("user_id"),
        "property_id": widget.property_id,
        "booking_id": widget.booking_id,
        "payment_mode": widget.payment_id.toString(),
        "payment_ref": paymentRef_content.text,
        "payment_slip": image1
      });

      try {
        final response = await dio.post(RemoteConnections.PAYMENT_PROOF_URL, data: formData);
        print(response.data);

        var verify = null;
        verify = response.data;

        if(verify["status"] == 'SUCCESS'){
          setState(() {
            isLoading = false;
            paymentMode_content.text = '';
            paymentRef_content.text = '';

            msg2 = verify['message'];
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Column(
                    children: [
                      Text('Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                      Divider(),
                      Text(msg2, style: TextStyle(fontSize: 16,),)
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Alright', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                        onPressed: () async {
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
                          //Navigator.pop(context, false);
                        }
                    )
                  ],
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
                      Text('Confirmation', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                      Divider(),
                      Text(msg, style: TextStyle(fontSize: 16,),)
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Alright', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                      onPressed: () => Navigator.pop(context, false),
                    )
                  ],
                )
            );
          });
        }
      }catch(e) {
        //final errorMessage = DioExceptions.fromDioError(e).toString();
        print(e);
      }

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentMode_content.text = widget.paymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    final paymentMode = TextField(
      obscureText: false,
      autofocus: false,
      enabled: false,
      style: style,
      keyboardType: TextInputType.text,
      controller: paymentMode_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final paymentRef = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.number,
      controller: paymentRef_content,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintText: ''
      ),
    );

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      //color: Color(0xff01A0C7),
      color: Colors.blueAccent.withOpacity(0.9),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(paymentMode_content.text == ""){
            setState(() {
              msg = "Payment Method is required";
            });
          } else if(paymentRef_content.text == ""){
            setState(() {
              msg = "Transaction ref is required";
            });
          } else if(images.isEmpty){
            setState(() {
              msg = "Receipt photo is required";
            });
          }else{
            setState(() {
              isLoading = true;
            });
            paymentProof();
          }
        },
        child: Text("Submit",
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
        title: Text("Payment Proof"),
      ),
      body: isLoading ? Center(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      )) : ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            //child: Text(msg, style: TextStyle(color: Colors.red),),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0, top: 5, right: 20, bottom: 0),
            child: Row(
              children: [
                Text("Payment Method", style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left:20.0, top: 5, right: 20, bottom: 10),
            child: Container(height: 40.0,child: paymentMode),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.only(left:20.0, top: 5, right: 20, bottom: 0),
            child: Row(
              children: [
                Text("Enter Transaction Reference", style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left:20.0, top: 5, right: 20, bottom: 20),
            child: Container(height: 40.0,child: paymentRef),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left:20.0, top: 5, right: 20, bottom: 0),
            child: Row(
              children: [
                Text("Attach A Receipt Photo", style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
            child: ElevatedButton(
              child: Text("Select Receipt Photo"),
              onPressed: loadAssets,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 0.0),
            child: Container(
              height: 150,
              child: buildGridView(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0, top: 10, right: 20, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(msg, style: TextStyle(color: Colors.red, fontSize: 16),),
              ],
            ),
          ),
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

// class DioExceptions implements Exception {
//
//   DioExceptions.fromDioError(DioError dioError) {
//     switch (dioError.type) {
//       case DioErrorType.CANCEL:
//         message = "Request to API server was cancelled";
//         break;
//       case DioErrorType.CONNECT_TIMEOUT:
//         message = "Connection timeout with API server";
//         break;
//       case DioErrorType.DEFAULT:
//         message = "Connection to API server failed due to internet connection";
//         break;
//       case DioErrorType.RECEIVE_TIMEOUT:
//         message = "Receive timeout in connection with API server";
//         break;
//       case DioErrorType.RESPONSE:
//         message =
//             _handleError(dioError.response.statusCode, dioError.response.data);
//         break;
//       case DioErrorType.SEND_TIMEOUT:
//         message = "Send timeout in connection with API server";
//         break;
//       default:
//         message = "Something went wrong";
//         break;
//     }
//   }
//
//   String message;
//
//   String _handleError(int statusCode, dynamic error) {
//     switch (statusCode) {
//       case 400:
//         return 'Bad request';
//       case 404:
//         return error["message"];
//       case 500:
//         return 'Internal server error';
//       default:
//         return 'Oops something went wrong';
//     }
//   }
//
//   @override
//   String toString() => message;
// }

