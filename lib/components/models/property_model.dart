
class PropertyModel {
  int property_id;
  String property_title;
  String brief_description;
  String other_description;
  String property_ref;
  String property_mode;
  String condition;
  String property_size;
  String address;
  String isOccupied;
  String latitude;
  String longitude;
  String facilities;
  int property_cost;
  int bedrooms;
  int bathrooms;
  int toilets;
  List<gallery> images;

  PropertyModel({ required this.property_id, required this.property_title, required this.brief_description, required this.other_description,
    required this.property_ref, required this.property_mode, required this.condition, required this.property_size, required this.property_cost,
    required this.address, required this.latitude, required this.longitude, required this.facilities,required this.isOccupied, required this.bedrooms,
    required this.bathrooms, required this.toilets, required this.images});

  factory PropertyModel.fromJson(Map<String, dynamic> parsedJson) {
    return PropertyModel(
        property_id: parsedJson['property_id'],
        property_title: parsedJson['property_title'],
        brief_description: parsedJson['brief_description'],
        other_description: parsedJson['other_description'],
        property_ref: parsedJson['property_ref'],
        property_mode: parsedJson['property_mode'],
        condition: parsedJson['condition'],
        property_size: parsedJson['property_size'],
        address: parsedJson['address'],
        isOccupied: parsedJson['isOccupied'],
        property_cost: parsedJson['property_cost'],
        latitude: parsedJson['latitude'],
        longitude: parsedJson['longitude'],
        facilities: parsedJson['facilities'],
        bedrooms: parsedJson['bedrooms'],
        bathrooms: parsedJson['bathrooms'],
        toilets: parsedJson['toilets'],
        images: (parsedJson['gallery'] as List).map((i) => gallery.fromJson(i)).toList()
    );
  }
}

class gallery {
  int id;
  String image_path;
  gallery({required this.id, required this.image_path});

  factory gallery.fromJson(Map<String, dynamic> parsedJson) {
    return gallery(
        id: parsedJson['id'],
        image_path: parsedJson['image_path']
    );
  }
}