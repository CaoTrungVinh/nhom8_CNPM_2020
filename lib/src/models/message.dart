class Message {
  final int id;
  final bool isMine;
  final String content;
  final DateTime createdAt;

  Message({
    this.isMine,
    this.content,
    this.createdAt,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isMine': isMine,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Message.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        isMine = data['isMine'],
        content = data['content'],
        createdAt = DateTime.parse(data['createdAt']);
}
