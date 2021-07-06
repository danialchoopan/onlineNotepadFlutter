class Note {
  int? id;
  int? userId;
  String? content;

  Note({this.id, this.userId, this.content});

  //convert to json
  factory Note.formJson(Map<String, dynamic> json) {
    return Note(
        id: int.parse(json['id'].toString()),
        userId: int.parse(json['user_id'].toString()),
        content: json['content']);
  }
}
