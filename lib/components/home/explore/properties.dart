import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/explore/horizontal_filters.dart';
import 'package:birungi_estates/components/models/property_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PropertiesExplore extends StatefulWidget {
  @override
  _PropertiesExploreState createState() => _PropertiesExploreState();
}

class _PropertiesExploreState extends State<PropertiesExplore> {
  TextEditingController search = TextEditingController();

  late int listCount;
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
    final loader = Material(
      elevation: 5.0,
      child: Card(
        child: Container(
          height: 80,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Getting Facilities"),
              )
            ],
          ),
        ),
      ),
    );

    final searchFacility = Container(
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
      // appBar: AppBar(
      //   backgroundColor: Colors.blueAccent,
      //   title: Text("Birungi Estates"),
      // ),
      body: FutureBuilder(
          future: getAllFacilities(),
          builder: (context, snapshot) {
            if(listCount == 0){
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: loader,
              )) : Center( child: Container(
                child: Text("There are no facilities to show", style: TextStyle(fontSize: 16.0),),
              ));
            }else{
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: loader,
              )) : Column(
                children: [
                  Container(
                    height: 70,
                    child: Container(
                      color: Colors.blueAccent,
                      padding: EdgeInsets.only(left: 6.0, top: 0.0, right: 6.0, bottom: 0.0),
                      child: searchFacility,
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
      itemCount: facilityForDisplay.length,
      itemBuilder: (context, index) {
        var facility = facilityForDisplay[index];
        var i = 0;
        for(i = 0; i < facilityGallery.length; i++){
          facilityGallery[i];
        }
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
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
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${facility.images[i].image_path}'),
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
                          borderRadius: BorderRadius.all(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${facility.property_title}', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                              //Text('UGX ' + '${facility.property_cost}'.replaceAllMapped(reg, mathFunc), style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            ],
                          )
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
                          )
                        ],
                      ),
                      SizedBox(height: 4,),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(''),
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
            // Navigator.of(context).push(new MaterialPageRoute(
            //     builder: (context) => StorageDetails(
            //       categoryRef: '${facility.category_ref}',
            //       subCategoryName: '${facility.subcategory_name}',
            //       facilityID: '${facility.facility_id}',
            //       facilityName: '${facility.facility_name}',
            //       ownerID: '${facility.owner_id}',
            //       ownerName: '${facility.owner_name}',
            //       cost: '${facility.cost_per_day}',
            //       location: '${facility.location}',
            //       image_1: '${facility.image_1}',
            //       image_2: '${facility.image_2}',
            //       image_3: '${facility.image_3}',
            //       image_4: '${facility.image_4}',
            //       image_5: '${facility.image_5}',
            //       description: '${facility.discription}',
            //       phoneNumber: '${facility.phone_number}',
            //     )));
          },
        );
      },
    );
  }
}
