import 'dart:io';

import 'package:birungi_estates/components/constants/serverApis.dart';
import 'package:birungi_estates/components/home/filters/subcategories.dart';
import 'package:birungi_estates/components/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController search = TextEditingController();

  int listCount = 0;
  bool _isLoading = true;
  String msg = '';
  List<CategoriesModel> category = [];
  List<CategoriesModel> categoryForDisplay = [];

  Future<List<CategoriesModel>> getAllBookings() async {
    try {
      final response = await http.get(Uri.parse(RemoteConnections.CATEGORIES_URL));
      //print(response.body);
      List<CategoriesModel> markList = [];

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dataCategories = jsonData['data'] as List;
        //print(dataCategories);

        if(dataCategories != null){
          _isLoading = false;
        }
        else if(dataCategories == null ){
          _isLoading = false;
        }

        markList = dataCategories.map<CategoriesModel>((json) => CategoriesModel.fromJson(json)).toList();
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
            hintText: "Search category",
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
        title: Text("Filters"),
      ),
      body: FutureBuilder(
          future: getAllBookings(),
          builder: (context, snapshot) {
            if(listCount == 0){
              return _isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )) : Center( child: Container(
                child: Text("There are no categories to show", style: TextStyle(fontSize: 16.0),),
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
                builder: (context) => Subcategories(
                  category_id: category.id,
                  name: '${category.name}',
                )));
          },
        );
      },
    );
  }
}
