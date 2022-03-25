
class PaymentModel {
  int id;
  String name;
  String details;

  PaymentModel({required this.id, required this.name, required this.details});

  factory PaymentModel.fromJson(Map<String, dynamic> parsedJson) {
    return PaymentModel(
        id: parsedJson['id'],
        name: parsedJson['name'],
        details: parsedJson['details']
    );
  }
}