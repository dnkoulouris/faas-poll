class PollOption {
  String? id;
  String? title;

  PollOption();

  PollOption.fromMap(this.id, map) {
    if (map is Map) {
      title = map['title'];
    }
  }

  Map<String, dynamic> toMap() => {
    'title': title,
  };

}
