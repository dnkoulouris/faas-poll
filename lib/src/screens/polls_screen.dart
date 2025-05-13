import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:football_as_a_service/src/model/poll.dart';
import 'package:football_as_a_service/src/repository/polls_repository.dart';
import 'package:get/get.dart';

class PollsScreen extends StatelessWidget {
  const PollsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Polls")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreatePollDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: FirestoreListView<Map<String, dynamic>>(
        query: FirebaseFirestore.instance.collection('polls'),
        itemBuilder: (context, snapshot) {
          Poll poll = Poll.fromMap(snapshot.id, snapshot.data());
          return ListTile(title: Text(poll.title ?? '-'), onTap: () {
            Get.toNamed("/poll/${poll.id}");
          });
        },
      ),
    );
  }

  void showCreatePollDialog(BuildContext context) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create Poll"),
          content: TextField(controller: titleController, decoration: InputDecoration(labelText: "Poll Title")),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  PollsRepository.createPoll(title);
                  Navigator.pop(context);
                }
              },
              child: Text("Create"),
            ),
          ],
        );
      },
    );
  }
}
