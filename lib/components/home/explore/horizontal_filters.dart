
import 'package:birungi_estates/components/home/explore/bungalows.dart';
import 'package:birungi_estates/components/home/explore/rentals.dart';
import 'package:birungi_estates/components/home/explore/villas.dart';
import 'package:birungi_estates/components/home/filters/categories.dart';
import 'package:flutter/material.dart';

import 'apartments.dart';
import 'duplex.dart';

class HorizontalFiltersExplore extends StatelessWidget {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  TextEditingController minPrice_content = TextEditingController();
  TextEditingController maxPrice_content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final minPrice = TextField(
      obscureText: false,
      style: style,
      controller: minPrice_content,
      keyboardType: TextInputType.number,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            hintText: "Min Price",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            hintStyle: TextStyle(color: Colors.grey)
        ),
    );

    final maxPrice = TextField(
      obscureText: false,
      style: style,
      controller:  maxPrice_content,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          hintText: "Max Price",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintStyle: TextStyle(color: Colors.grey)
      ),
    );
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Container(
            height: 32,
            child: Stack(
              children: [
                ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => RentalsExplorePage())
                        );
                      },
                        child: buildFilter("Rentals")
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => ApartmentsExplorePage())
                        );
                      },
                        child: buildFilter("Apartments")
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => BungalowsExplorePage())
                          );
                        },
                        child: buildFilter("Bungalow")
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => DuplexExplorePage())
                          );
                        },
                        child: buildFilter("Duplex")),
                    InkWell(
                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => VillasExplorePage())
                          );
                        },
                        child: buildFilter("Villas")),
                  ],
                )
              ],
            ),
          )),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Categories(
                    )));
              },
                child: const Text("Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),)),
          )
        ],
      ),
    );
  }

  Widget buildFilter(String filterName){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1
        ),
      ),
      child: Center(
        child: Text(filterName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
