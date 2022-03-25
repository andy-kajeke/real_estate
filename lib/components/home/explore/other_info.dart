import 'package:birungi_estates/components/models/property_model.dart';
import 'package:flutter/material.dart';

class OtherInfo extends StatelessWidget {
  final PropertyModel propertyModel;

  OtherInfo({required this.propertyModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("More Info"),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Text("Condition", style: TextStyle(fontSize: 16),)),
                    Expanded(child: Text(propertyModel.condition, style: TextStyle(fontSize: 16),)),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Text("Total Bedrooms", style: TextStyle(fontSize: 16),)),
                    Expanded(child: Text(propertyModel.bedrooms.toString(), style: TextStyle(fontSize: 16),)),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Text("Total Bathrooms", style: TextStyle(fontSize: 16),)),
                    Expanded(child: Text(propertyModel.bathrooms.toString(), style: TextStyle(fontSize: 16),)),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Text("Total Toilets", style: TextStyle(fontSize: 16),)),
                    Expanded(child: Text(propertyModel.toilets.toString(), style: TextStyle(fontSize: 16),)),
                  ],
                ),
              )
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Other Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(propertyModel.other_description, style: TextStyle(fontSize: 16),),
              ),
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Special Features", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(propertyModel.facilities, style: TextStyle(fontSize: 16),),
              ),
            ],
          )
        ],
      ),
    );
  }
}
