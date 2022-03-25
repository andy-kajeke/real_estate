import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/explore/property_information.dart';
import 'package:birungi_estates/components/models/property_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class DuplexExplorePage extends StatefulWidget {
  @override
  _DuplexExplorePageState createState() => _DuplexExplorePageState();
}

class _DuplexExplorePageState extends State<DuplexExplorePage> {
  TextEditingController search = TextEditingController();

  int listCount = 0;
  bool _isLoading = true;
  String msg = '';
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  var mathFunc = (Match match) => '${match[1]},';

  List<PropertyModel> facility = [];
  List<gallery> facilityGallery = [];
  List<PropertyModel> facilityForDisplay = [];

  Future<List<PropertyModel>> getAllFacilities() async {
    Map data = {
      "category_id": '1',
      "sub_category_id": '4'
    };

    try {
      final response = await http.post(Uri.parse(RemoteConnections.GET_ALL_PROPERTIES_URL), body: data);
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
      //print("List Size: $listCount");
      return markList;
    } on SocketException {
      throw msg = 'No Internet connection';
    }
  }

  @override
  void initState() {
    super.initState();
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
          onTap: (){
          },
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
                        Radius.circular(10)
                    )
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: ShimmerWidget.rectangular(height: 120,),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ShimmerWidget.rectangular(height: 16, width: 150,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ShimmerWidget.rectangular(height: 16, width: 100,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ShimmerWidget.rectangular(height: 16, width: 80,),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
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
                child: Text("Getting Duplex"),
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
              var location = data.address.toLowerCase();
              return location.contains(text);
            }).toList();
          });
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Duplex"),
      ),
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
                  Container(
                    height: 70,
                    child: Container(
                      color: Colors.blueAccent,
                      padding: EdgeInsets.only(left: 6.0, top: 0.0, right: 6.0, bottom: 0.0),
                      child: searchFacility,
                    ),
                  ),
                  SizedBox(height: 4,),
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
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => PropertyInformation(
                  propertyModel: facilityForDisplay[index],
                )));
          },
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
                        Radius.circular(10)
                    )
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          height: 140,
                          child: Image.network('${facility.images[0].image_path}',fit: BoxFit.cover,)
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${facility.property_title}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${facility.address}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('UGX '+ '${facility.property_cost}'.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
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
            leading: Icon(Icons.menu, color: Theme.of(context).primaryColor,),
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
                icon: Icon(Icons.search, color: Theme.of(context).primaryColor), onPressed: () {},),
              IconButton(icon: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
                onPressed: () {},)
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

