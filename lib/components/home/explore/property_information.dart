import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/explore/map.dart';
import 'package:birungi_estates/components/home/explore/other_info.dart';
import 'package:birungi_estates/components/home/explore/view_photos.dart';
import 'package:birungi_estates/components/models/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class PropertyInformation extends StatefulWidget {
  final PropertyModel propertyModel;

  PropertyInformation({required this.propertyModel});
  @override
  _PropertyInformationState createState() => _PropertyInformationState();
}

class _PropertyInformationState extends State<PropertyInformation> {

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  var mathFunc = (Match match) => '${match[1]},';

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final Geolocator geolocator = Geolocator();
  late Position _currentPosition;
  late String _currentAddress;
  late double currentLong;
  late double currentLat;
  late double endLatitude;
  late double endLongitude;
  late double distanceInMeters;
  late double distanceInKiloMeters;
  double roundDistanceInKM = 0.0;

  String ownerPhoto = "https://services.data-intell.co.uk/keepkeep/user_photo/holder.png";
  String Line = "";
  String msg = 'Are you really sure you want to inspect this property?..';

  //List<gallery> getAllPhotos = List<gallery>();
  ////////////////////////////////////////////////distance in km////////////////////////////////////////////////////
  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    currentLong = _currentPosition.longitude;
    currentLat = _currentPosition.latitude;
    endLatitude = double.parse(widget.propertyModel.latitude);
    endLongitude = double.parse(widget.propertyModel.longitude);

    distanceInMeters = await Geolocator.distanceBetween(currentLat, currentLong, endLatitude, endLongitude);

    distanceInKiloMeters = distanceInMeters / 1000;
    roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(2));

    // try {
    //   List<Placemark> p = await geolocator.placemarkFromCoordinates(
    //       _currentPosition.latitude, _currentPosition.longitude);
    //
    //   Placemark place = p[0];
    //
    //   setState(() {
    //     _currentAddress =
    //     "${place.locality}, ${place.postalCode}, ${place.country}";
    //
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  bookNow() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("user_id"),
      "property_id": widget.propertyModel.property_id.toString(),
      "notes":"Hello, I am Interested in the Property"
    };
    var response = await http.post(Uri.parse(RemoteConnections.BOOK_REQUEST_URL), body: data);
    print(response.body);
    var notify = null;
    notify = json.decode(response.body);

    try {
      if(notify["status"] == 'Failed'){
        msg = notify["message"];
        print(notify["message"]);
      }
      else if(notify["status"] == 'SUCCESS'){
        msg = notify["message"] + ' Check reservations for details.';
        print(notify["message"]);
      }
    } on SocketException {
      throw msg = 'No Internet connection';
    }
  }

  final Email propertyInquiry = Email(
    body: 'Message',
    subject: 'Birungi Estates Client Inquiring on property',
    recipients: ['birungiinvestment@yahoo.com'],
    //cc: [''],
    isHTML: false,
  );

  _launchCaller() async {
    const url = 'tel: 256758309356';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /////////////////////////////////////////////////////////////////check gps activation////////////////////////////////////////////
  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Enable GPS Location"),
              content:
              const Text('Please make sure you enable GPS location for easy navigation on the map'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            );
          },
        );
      }
      else if (Theme.of(context).platform == TargetPlatform.iOS) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Enable GPS location"),
              content:
              const Text('Please make sure you enable GPS location for easy navigation on the map'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    AppSettings.openLocationSettings;
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkGps();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blueAccent,
      //   title: Text(propertyModel.address),
      // ),
      body: Stack(
        children: [
          Hero(
            tag: widget.propertyModel.images[0].image_path,
            child: Container(
              height: size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.propertyModel.images[0].image_path),
                    //fit: BoxFit.cover
                  )
              ),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.4, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7)
                        ]
                    )
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      )
                    ],
                  ),
                ),
                //Expanded(child: Container()),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 0.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.yellow[700],
                //       borderRadius: BorderRadius.all(
                //           Radius.circular(5)
                //       ),
                //     ),
                //     width: 80,
                //     padding: EdgeInsets.symmetric(vertical: 4),
                //     child: Center(
                //       child: Text(widget.propertyModel.property_mode.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                //     ),
                //   ),
                // ),
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.0),
                  child: Column(
                    children: [
                      Text(widget.propertyModel.property_title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white, size: 20,),
                              SizedBox(width: 2,),
                              Text(widget.propertyModel.address, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(roundDistanceInKM.toString() + ' km away', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:  Container(
              height: size.height * 0.70,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      // image: DecorationImage(
                                      //   image: NetworkImage('${ownerPhoto}'),
                                      //   fit: BoxFit.cover
                                      // ),
                                      shape: BoxShape.circle
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1/1,
                                    child: ClipOval(
                                        child: Image.asset(
                                          'images/home.png',
                                          fit: BoxFit.cover,)
                                    ),
                                  )
                              ),
                              SizedBox(width: 8,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('REF: '+ widget.propertyModel.property_ref.toUpperCase(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 5,),
                                  Text('UGX ' + widget.propertyModel.property_cost.toString().replaceAllMapped(reg, mathFunc) + " / month", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) => MapScreen(
                                          fromLatitude: currentLat,
                                          fromLongitude: currentLong,
                                          destLatitude: endLatitude,
                                          destLongitude: endLongitude,
                                        )
                                    )
                                );
                              },
                              child: buildFeature(Icons.location_on, 'On Map')
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Column(
                                        children: [
                                          Text('Inspection Request', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                                          Divider(),
                                          Text(msg, style: TextStyle(fontSize: 16,),)
                                        ],
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: const Text('NO', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                                          onPressed: () => Navigator.pop(context, false),
                                        ),
                                        FlatButton(
                                            child: Text('YES', style: const TextStyle(fontSize: 16, color: Colors.redAccent)),
                                            onPressed: () async {
                                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                              Map data = {
                                                "user_id": sharedPreferences.getString("user_id"),
                                                "property_id": widget.propertyModel.property_id.toString(),
                                                "notes":"Hello, I am Interested in the Property"
                                              };
                                              var response = await http.post(Uri.parse(RemoteConnections.BOOK_REQUEST_URL), body: data);
                                              print(response.body);
                                              var notify = null;
                                              notify = json.decode(response.body);

                                              try {
                                                if(notify["status"] == 'Failed'){
                                                  msg = notify["message"];
                                                  print(notify["message"]);
                                                }
                                                else if(notify["status"] == 'SUCCESS'){
                                                  msg = notify["message"];
                                                  print(notify["message"]);
                                                }
                                              } on SocketException {
                                                throw msg = 'No Internet connection';
                                              };
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Column(
                                                      children: [
                                                        Text('Inspection Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                                                        Divider(),
                                                        Text(msg, style: TextStyle(fontSize: 16,),)
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      // FlatButton(
                                                      //   child: Text('NO', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                                                      //   onPressed: () => Navigator.pop(context, false),
                                                      // ),
                                                      FlatButton(
                                                          child: Text('Alright', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                                                          onPressed: () {
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
                                                          }
                                                      )
                                                    ],
                                                  )
                                              );
                                            }
                                        )
                                      ],
                                    )
                                );
                              },
                              child: buildFeature(Icons.thumb_up, 'Inspect Now')
                          ),
                          InkWell(
                              onTap: () async {
                                await FlutterEmailSender.send(propertyInquiry);
                              },
                              child: buildFeature(Icons.email, 'Send Email')),
                          InkWell(
                              onTap: () {
                                _launchCaller();
                              },
                              child: buildFeature(Icons.call, 'Call Now')
                          ),
                          //buildFeature(Icons.call, 'Call Now'),

                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
                      child: Text("Property Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                            child: Text(widget.propertyModel.brief_description, style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey[500]),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                            child: Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey[500]),),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                            child: InkWell(
                                onTap: (){
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (context) => OtherInfo(
                                            propertyModel: widget.propertyModel,
                                          )
                                      )
                                  );
                                },
                                child: Text('View More Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),)),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                      child: Text("Property Photos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                          child: ListView.builder(
                            itemCount: widget.propertyModel.images.length,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              var photo = widget.propertyModel.images[index];
                              //print('===='+ photo.image_path);
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (context) => ViewPropertyPhotos(
                                        propertyModel: widget.propertyModel,
                                      ))
                                  );
                                },
                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(photo.image_path),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeature(IconData iconData, String text){
    return Column(
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
              iconData,
              color: Colors.blueAccent[700],
              size: 20,
            ),
          ),
        ),
        SizedBox(height: 5,),
        Text(text, style: TextStyle(color: Colors.grey[500], fontSize: 14),)
      ],
    );
  }
}
