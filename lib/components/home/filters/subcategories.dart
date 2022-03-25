import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/models/subcategories_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'filtered_properties.dart';

class Subcategories extends StatefulWidget {
  final int category_id;
  final String name;

  Subcategories({required this.category_id, required this.name});
  @override
  _SubcategoriesState createState() => _SubcategoriesState();
}

class _SubcategoriesState extends State<Subcategories> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController search = new TextEditingController();

  int listCount = 0;
  bool _isLoading = true;
  String msg = '';
  List<SubcategoriesModel> category = [];
  List<SubcategoriesModel> categoryForDisplay = [];

  Future<List<SubcategoriesModel>> getAllBookings() async {
    Map data = {
      "category_id": widget.category_id.toString()
    };
    try {
      final response = await http.post(Uri.parse(RemoteConnections.SUBCATEGORIES_URL), body: data);
      //print(response.body);
      List<SubcategoriesModel> markList = [];

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dataSubcategories = jsonData['data'] as List;
        //print(dataSubcategories);

        if(dataSubcategories != null){
          _isLoading = false;
        }
        else if(dataSubcategories == null ){
          _isLoading = false;
        }

        markList = dataSubcategories.map<SubcategoriesModel>((json) => SubcategoriesModel.fromJson(json)).toList();
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
        category.addAll(value);
        categoryForDisplay = category;
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
            hintText: "Search subcategory",
            hintStyle: TextStyle(color: Colors.white)
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            categoryForDisplay = category.where((data) {
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
        title: Text(widget.name),
      ),
      body: FutureBuilder(
          future: getAllBookings(),
          builder: (context, snapshot) {
            if(listCount == 0){
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )) : Center( child: Container(
                child: Text("There are no subcategories to show", style: TextStyle(fontSize: 16.0),),
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
      itemCount: categoryForDisplay.length,
      itemBuilder: (context, index) {
        var category = categoryForDisplay[index];
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
                                            child: Text('${category.name[0]}',
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
                                Text('${category.name}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => FilteredProperties(
                  category_id: category.category_id,
                  subcategory_id: category.id,
                  name: '${category.name}',
                )));
          },
        );
      },
    );
  }
}
