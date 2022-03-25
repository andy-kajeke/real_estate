import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/explore/horizontal_filters.dart';
import 'package:birungi_estates/components/home/explore/property_information.dart';
import 'package:birungi_estates/components/home/filters/categories.dart';
import 'package:birungi_estates/components/models/property_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

import 'notifications.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  TextEditingController search = new TextEditingController();

  final Geolocator geolocator = Geolocator();
  late Position _currentPosition;
  late String _currentAddress;
  late double currentLong;
  late double currentLat;
  late double endLatitude;
  late double endLongitude;

  late double distanceInMeters;
  late double distanceInKiloMeters;
  late double roundDistanceInKM;

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

  /////////////////////////////////////////////////////////////////check gps activation////////////////////////////////////////////
  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Enable GPS Location"),
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
  int listCount = 0;
  bool _isLoading = true;
  String msg = '';
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  var mathFunc = (Match match) => '${match[1]},';

  List<PropertyModel> facility = [];
  List<gallery> facilityGallery = [];
  List<PropertyModel> facilityForDisplay = [];

  Future<List<PropertyModel>> getAllFacilities() async {

    try {
      final response = await http.post(Uri.parse(RemoteConnections.GET_ALL_PROPERTIES_URL));
      //print(response.body);
      List<PropertyModel> markList = [];

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dataFacilities = jsonData['data'] as List;

        if(dataFacilities != null){
          _isLoading = false;
        }
        else if(dataFacilities == null ){
          _isLoading = false;
        }

        markList = dataFacilities.map<PropertyModel>((json) => PropertyModel.fromJson(json)).toList();
      }

      //print("========Size=============");
      setState(() {
        listCount = markList.length;
      });
      print("List Size: $listCount");
      return markList;
    } on SocketException {
      throw msg = 'No Internet connection';
    }
  }

  @override
  void initState() {
    super.initState();
    _checkGps();

    getAllFacilities().then((value) {
      setState(() {
        facility.addAll(value);
        facilityForDisplay = facility;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loader2 = ListView.builder(
      itemCount: _isLoading ? 10 : facilityForDisplay.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 2.0,
            ),
            child: Card(
              margin: EdgeInsets.only(bottom: 10.0),
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)
                  )
              ),
              child: Container(
                height: 180,
                color: Colors.grey.shade300,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)
                          ),
                        ),
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Center(
                          child: ShimmerWidget.rectangular(height: 16, width: 50,)
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        children: const [
                          ShimmerWidget.rectangular(height: 16, width: 170,)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        children: [
                          Row(
                            children: const [
                              ShimmerWidget.rectangular(height: 16, width: 150,)
                            ],
                          ),
                          SizedBox(height: 5,),
                          // Row(
                          //   children: [
                          //     Text(roundDistanceInKM.toString() + ' km away', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),),
                          //   ],
                          // ),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),),
                              ShimmerWidget.rectangular(height: 16, width: 100,)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: (){
          },
        );
      },
    );

    final loader = Material(
      elevation: 5.0,
      child: Card(
        child: Container(
          height: 80,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Getting Facilities"),
              )
            ],
          ),
        ),
      ),
    );

    final searchFacility = Container(
      margin: const EdgeInsets.only(left:10.0, top: 15.0, right: 10.0, bottom: 15.0),
      padding: const EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 17.0),
        controller: search,
        decoration: const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white,),
            hintText: "Search by location",
            hintStyle: TextStyle(color: Colors.white)
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            facilityForDisplay = facility.where((data) {
              var location = data.property_title.toLowerCase();
              return location.contains(text);
            }).toList();
          });
        },
      ),
    );

    return Scaffold(
      appBar: _appBar(AppBar().preferredSize.height),
      body: FutureBuilder(
          future: getAllFacilities(),
          builder: (context, snapshot) {
            if(listCount == 0){
              return _isLoading ? loader2 : Center( child: Container(
                child: Text("There are no facilities to show", style: TextStyle(fontSize: 16.0),),
              ));
            }else{
              return _isLoading ? loader2 : Column(
                children: [
                  // Container(
                  //   height: 70,
                  //   child: Container(
                  //     color: Colors.blueAccent,
                  //     padding: EdgeInsets.only(left: 6.0, top: 0.0, right: 6.0, bottom: 0.0),
                  //     child: searchFacility,
                  //   ),
                  // ),
                  HorizontalFiltersExplore(),
                  SizedBox(height: 5,),
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
      itemCount: facilityForDisplay.length,
      itemBuilder: (context, index) {
        var facility = facilityForDisplay[index];

        return InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 2.0,
            ),
            child: Card(
              margin: EdgeInsets.only(bottom: 10.0),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)
                  )
              ),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${facility.images[0].image_path}'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.5, 1.0],
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7)
                          ]
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: const BorderRadius.all(
                              Radius.circular(5)
                          ),
                        ),
                        width: 80,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Center(
                          child: Text('${facility.property_mode}'.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        children: [
                          Text('${facility.property_title}', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white, size: 18,),
                              SizedBox(width: 2,),
                              Text('${facility.address}', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          // Row(
                          //   children: [
                          //     Text(roundDistanceInKM.toString() + ' km away', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),),
                          //   ],
                          // ),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),),
                              Text('UGX ' + '${facility.property_cost}'.replaceAllMapped(reg, mathFunc), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => PropertyInformation(
                  propertyModel: facilityForDisplay[index],
                )));
          },
        );
      },
    );
  }

  _appBar(height) => PreferredSize(
    preferredSize:  Size(MediaQuery.of(context).size.width, height+80 ),
    child: Stack(
      children: <Widget>[
        Container(     // Background
          child: Center(
            child: Text("Birungi Estates", style: TextStyle(fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),),),
          color:Theme.of(context).primaryColor,
          height: height+75,
          width: MediaQuery.of(context).size.width,
        ),

        Container(),   // Required some widget in between to float AppBar

        Positioned(    // To take AppBar Size only
          top: 100.0,
          left: 20.0,
          right: 20.0,
          child: AppBar(
            backgroundColor: Colors.white,
            leading: Icon(Icons.search, color: Theme.of(context).primaryColor,),
            primary: false,
            title: TextField(
              autofocus: false,
                decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey)
                ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  facilityForDisplay = facility.where((data) {
                    var title = data.property_title.toLowerCase();
                    var location = data.address.toLowerCase();
                    return title.contains(text);
                  }).toList();
                });
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Categories(
                      )));
                },),
              IconButton(
                icon: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Notifications(
                      )));
                },)
            ],
          ),
        )

      ],
    ),
  );
}

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    this.width = 50.0,
    this.height = double.infinity,
    this.shapeBorder = const RoundedRectangleBorder()
  });

  const ShimmerWidget.circular({
    this.width = 50.0,
    this.height = double.infinity,
    this.shapeBorder = const CircleBorder()
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
            color: Colors.grey,
            shape: shapeBorder
        ),
      ),
    );
  }
}

