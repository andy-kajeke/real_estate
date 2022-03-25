
class BookingModel {
  int booking_id;
  String booking_ref;
  int property_id;
  String booking_type;
  String notes;
  String status;
  String created_at;

  BookingModel({required this.booking_id, required this.booking_ref, required this.property_id, required this.booking_type,
    required this.notes, required this.status, required this.created_at});

  factory BookingModel.fromJson(Map<String, dynamic> parsedJson) {
    return BookingModel(
        booking_id: parsedJson['booking_id'],
        booking_ref: parsedJson['booking_ref'],
        property_id: parsedJson['property_id'],
        booking_type: parsedJson['booking_type'],
        notes: parsedJson['notes'],
        status: parsedJson['status'],
        created_at:parsedJson['created_at']
    );
  }
}