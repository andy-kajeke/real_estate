
class NotificationModel {
  int notification_id;
  String title;
  String message;

  NotificationModel({required this.notification_id, required this.title, required this.message});

  factory NotificationModel.fromJson(Map<String, dynamic> parsedJson) {
    return NotificationModel(
        notification_id: parsedJson['notification_id'],
        title: parsedJson['title'],
        message: parsedJson['message']
    );
  }
}