import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_as_a_service/src/model/poll.dart';
import 'package:football_as_a_service/src/repository/polls_repository.dart';
import 'package:get/get.dart';

class PollsScreen extends StatelessWidget {
  const PollsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text('Polls'),
            actions: user != null
                ? [
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                    )
                  ]
                : null,
          ),
          floatingActionButton: user != null
              ? FloatingActionButton(
                  onPressed: () {
                    showCreatePollDialog(context);
                  },
                  child: Icon(Icons.add),
                )
              : null,
          body: user != null
              ? FirestoreListView<Map<String, dynamic>>(
                  query: FirebaseFirestore.instance.collection('polls'),
                  itemBuilder: (context, snapshot) {
                    Poll poll = Poll.fromMap(snapshot.id, snapshot.data());
                    return ListTile(
                      title: Text(poll.title ?? '-'),
                      onTap: () {
                        Get.toNamed("/poll/${poll.id}");
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete poll'),
                              content: Text('Are you sure you want to delete this poll?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await PollsRepository.deletePoll(poll.id!);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Delete failed: $e')),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                )
              : _buildSignInPrompt(context),
        );
      },
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

  Widget _buildSignInPrompt(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You must be signed in to view polls.'),
            SizedBox(height: 12),
            SizedBox(
              width: 320,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 320,
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Enter email and password')),
                      );
                      return;
                    }

                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign-in failed: $e')),
                      );
                    }
                  },
                  child: Text('Sign in'),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Enter email and password')),
                      );
                      return;
                    }

                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration failed: $e')),
                      );
                    }
                  },
                  child: Text('Register'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
