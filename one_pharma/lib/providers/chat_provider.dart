import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/models/chat_message_model.dart';
import '../data/mock/mock_data.dart';

class ChatNotifier extends StateNotifier<List<ChatMessageModel>> {
  ChatNotifier() : super(MockData.chatMessages);

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final now = DateTime.now();
    final timeStr = DateFormat('hh:mm a').format(now);

    final userMsg = ChatMessageModel(
      id: 'msg_${now.millisecondsSinceEpoch}',
      text: text.trim(),
      isUser: true,
      time: timeStr,
    );

    state = [...state, userMsg];

    // Trigger realistic automated pharmacy reply after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      final autoReply = _generateResponse(text);
      final replyMsg = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        text: autoReply,
        isUser: false,
        time: DateFormat('hh:mm a').format(DateTime.now()),
        senderName: 'Pharmacist Support',
      );
      state = [...state, replyMsg];
    });
  }

  String _generateResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('prescription') || lower.contains('rx')) {
      return 'Prescriptions are verified by our on-duty licensed pharmacist within 15–30 minutes of order placement.';
    } else if (lower.contains('delivery') || lower.contains('track') || lower.contains('where')) {
      return 'Your delivery rider location is updated live in the Order Status screen with an estimated arrival time.';
    } else if (lower.contains('refund') || lower.contains('return')) {
      return 'Refunds for unapproved prescriptions or cancelled orders are processed back to your payment method within 24-48 hours.';
    } else if (lower.contains('hi') || lower.contains('hello')) {
      return 'Hello! How can our pharmacy care team help you today?';
    } else {
      return 'Thank you for reaching out. A registered pharmacy agent has received your query and is reviewing your request.';
    }
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessageModel>>((ref) {
  return ChatNotifier();
});
