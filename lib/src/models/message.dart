enum MessageType {
  HTML,
  TEXT,
}

class Message {
  final int id;
  final bool isMine;
  final String content;
  final DateTime createdAt;
  final MessageType messageType;

  Message({
    this.isMine,
    this.content,
    this.createdAt,
    this.id,
    this.messageType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isMine': isMine,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'messageType': messageType == MessageType.HTML ? 'html' : 'text',
    };
  }

  Message.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        isMine = data['isMine'],
        content = data['content'],
        createdAt = DateTime.parse(data['createdAt']),
        messageType =
            data['messageType'] == 'html' ? MessageType.HTML : MessageType.TEXT;
}
