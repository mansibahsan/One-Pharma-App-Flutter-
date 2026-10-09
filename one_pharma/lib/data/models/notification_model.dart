enum NotificationGroup {
  today,
  yesterday,
  lastWeek;

  String get title {
    switch (this) {
      case NotificationGroup.today:
        return 'Today';
      case NotificationGroup.yesterday:
        return 'Yesterday';
      case NotificationGroup.lastWeek:
        return 'Last week';
    }
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationGroup group;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.group,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    NotificationGroup? group,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      group: group ?? this.group,
      isRead: isRead ?? this.isRead,
    );
  }
}
