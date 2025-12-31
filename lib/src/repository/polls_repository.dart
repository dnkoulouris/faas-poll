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

  static Future<void> deletePoll(String id) async {
    final pollRef = FirebaseFirestore.instance.collection('polls').doc(id);

    // Delete subcollection 'participations' documents first
    final partsColl = pollRef.collection('participations');
    final partsSnapshot = await partsColl.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in partsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit deletions for participations (if any)
    if (partsSnapshot.docs.isNotEmpty) {
      await batch.commit();
    }

    // Delete the poll document
    await pollRef.delete();
  }
}
