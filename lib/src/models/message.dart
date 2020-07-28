class Message {
  final int id;
  final bool isMine;
  final String content;
  final DateTime createdAt;
  final int creatorId;

  Message({
    this.isMine,
    this.content,
    this.createdAt,
    this.creatorId,
    this.id,
  });
}
