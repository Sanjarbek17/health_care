import 'package:flutter/material.dart';
import 'package:health_care/models/message_model.dart';

class MessagesProvider extends ChangeNotifier {
  final List<MessageProvider> _messages = [
    MessageProvider(message: MessageModel(role: 'assistant', content: 'Do you have any other symptoms?')),
    MessageProvider(message: MessageModel(role: 'user', content: 'I have a headache.')),
    MessageProvider(message: MessageModel(role: 'assistant', content: 'Hello! How can I help you?')),
  ];

  List<MessageProvider> get messages => _messages;

  void addMessage(MessageProvider message) {
    _messages.insert(0, message);
    notifyListeners();
  }
}

class MessageProvider with ChangeNotifier {
  final MessageModel _message;

  MessageProvider({required MessageModel message}) : _message = message;

  MessageModel get message => _message;

  void updateMessage(String message) {
    _message.content += message;
    notifyListeners();
  }

  Map toJson() => _message.toJson();
}
