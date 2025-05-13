import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:football_as_a_service/src/model/poll.dart';

class PollsRepository {
  static Future<Poll?> getPoll(String id) async {
    final document = await FirebaseFirestore.instance.collection("polls").doc(id).get();
    if (!document.exists) {
      return null;
    }
    Poll poll = Poll.fromMap(document.id, document.data());
    return poll;
  }

  static Future<void> createPoll(String title) async {
    await FirebaseFirestore.instance.collection('polls').add({
      'title': title,
      'createdAt': DateTime.now().toIso8601String(),
      'expiresAt': null,
      'options': [],
    });
  }

  static Future<void> updatePoll(Poll poll) async {
    await FirebaseFirestore.instance.collection('polls').doc(poll.id).update(poll.toMap());
  }
}
