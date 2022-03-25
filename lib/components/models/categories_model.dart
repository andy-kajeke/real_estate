
class CategoriesModel {
  int id;
  String name;

  CategoriesModel({required this.id, required this.name});

  factory CategoriesModel.fromJson(Map<String, dynamic> parsedJson) {
    return CategoriesModel(
        id: parsedJson['id'],
        name: parsedJson['name']
    );
  }
}