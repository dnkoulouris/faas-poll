import 'package:football_as_a_service/src/model/poll_option.dart';

class Poll {
  String? id;
  String? title;
  DateTime? createdAt;
  DateTime? expiresAt;
  List<PollOption>? options;

  Poll();

  Poll.fromMap(this.id, map) {
    if (map is Map) {
      title = map['title'];
      createdAt = DateTime.tryParse(map['createdAt'] ?? '');
      expiresAt = DateTime.tryParse(map['expiresAt'] ?? '');
      if (map['options'] is List) {
        options = (map['options'] as List).map((e) => PollOption.fromMap(e['id'], e)).toList();
      }
    }
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'createdAt': createdAt?.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'options': options?.map((e) => e.toMap()).toList(),
  };
}
