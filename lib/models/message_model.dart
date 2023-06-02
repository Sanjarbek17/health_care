class MessageModel {
  String role;
  String content;

  MessageModel({required this.role, required this.content});

  Map<String, String> toJson() => {
        'role': role,
        'content': content,
      };
}
