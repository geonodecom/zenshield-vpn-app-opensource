NotificationMessage? notificationMessageFromJson(Map<String, dynamic> json) =>
    NotificationMessage._notificationMessagefromJson(json);

class NotificationMessage {
  final bool isShow;
  final String message;

  NotificationMessage({required this.isShow, required this.message});

  static NotificationMessage? _notificationMessagefromJson(
      Map<String, dynamic> json) {
    var isShow = json["showNotification"] as bool?;
    var message = json["message"];
    if (isShow == null && message == null) return null;
    return NotificationMessage(
      isShow: isShow ?? false,
      message: json["message"].toString(),
    );
  }
}
