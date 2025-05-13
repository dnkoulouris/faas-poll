import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:football_as_a_service/src/model/participation.dart';

class ParticipationsRepository {
  static createParticipation(String pollId, String name) async {
    await FirebaseFirestore.instance.collection('polls').doc(pollId).collection("participations").add({
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
      "removedBy": "none",
    });
  }

  static Stream<List<Participation>> listen(String pollId) {
    return FirebaseFirestore.instance
        .collection('polls')
        .doc(pollId)
        .collection("participations")
        .where("removedBy", isEqualTo: 'none')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Participation.fromMap(doc.id, doc.data())).toList());
  }

  static removeParticipation(String pollId, String partId) async {
    await FirebaseFirestore.instance.collection('polls').doc(pollId).collection("participations").doc(partId).update({
      "removedBy": "admin",
    });
  }
}
