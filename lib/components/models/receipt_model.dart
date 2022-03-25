
class ReceiptModel {
  int payment_id;
  String booking_ref;
  String property_ref;
  String property_title;
  String transaction_id;
  int amount;
  String payment_mode;
  String payment_ref;
  String status;
  String created_at;

  ReceiptModel({required this.payment_id, required this.booking_ref, required this.property_ref, required this.property_title, required this.transaction_id,
    required this.amount, required this.payment_mode, required this.payment_ref, required this.status, required this.created_at});

  factory ReceiptModel.fromJson(Map<String, dynamic> parsedJson) {
    return ReceiptModel(
        payment_id: parsedJson['payment_id'],
        booking_ref: parsedJson['booking_ref'],
        property_ref: parsedJson['property_ref'],
        property_title: parsedJson['property_title'],
        transaction_id: parsedJson['transaction_id'],
        amount: parsedJson['amount'],
        payment_mode: parsedJson['payment_mode'],
        payment_ref: parsedJson['payment_ref'],
        status: parsedJson['status'],
        created_at: parsedJson['created_at']
    );
  }
}