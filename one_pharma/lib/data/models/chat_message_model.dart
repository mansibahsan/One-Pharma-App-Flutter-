class ChatMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final String time;
  final String senderName;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.time,
    this.senderName = 'Pharmacist Support',
  });
}
