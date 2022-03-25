
class SubcategoriesModel {
  int id;
  String name;
  int category_id;

  SubcategoriesModel({required this.id, required this.name, required this.category_id});

  factory SubcategoriesModel.fromJson(Map<String, dynamic> parsedJson) {
    return SubcategoriesModel(
        id: parsedJson['id'],
        name: parsedJson['name'],
        category_id: parsedJson['category_id']
    );
  }
}