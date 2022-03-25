import 'package:birungi_estates/components/models/property_model.dart';
import 'package:flutter/material.dart';

class ViewPropertyPhotos extends StatelessWidget {
  final PropertyModel propertyModel;

  ViewPropertyPhotos({required this.propertyModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Property Photos"),
      ),
      body: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 150),
              child: ListView.builder(
                itemCount: propertyModel.images.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index){
                  var photo = propertyModel.images[index];
                  //print('===='+ photo.image_path);
                  return Container(
                    //height: 100,
                    width: MediaQuery.of(context).size.width - 0.2,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(photo.image_path),
                            fit: BoxFit.cover
                        )
                    ),
                  );
                },
              ),
            ),
          ),
    );
  }
}
