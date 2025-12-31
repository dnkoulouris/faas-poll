import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_as_a_service/src/model/participation.dart';
import 'package:football_as_a_service/src/repository/participations_repository.dart';
import 'package:football_as_a_service/src/screens/poll/poll_controller.dart';
import 'package:get/get.dart';

import '../../repository/polls_repository.dart';

class PollScreen extends StatelessWidget {
  final PollController controller = Get.put(PollController());

  PollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.pollRx.value.title ?? ''),
              if (FirebaseAuth.instance.currentUser != null)
              TextButton(
                onPressed: () {
                  showEditPollNameDialog(context);
                },
                child: Icon(Icons.edit),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddParticipation(context);
        },
        icon: Icon(Icons.add),
        label: Text("Add participation"),
      ),
      body:
          controller.id == null
              ? Container()
              : Obx(
                () => ListView.builder(
                  itemCount: controller.participationsRx.length,
                  itemBuilder: (context, index) {
                    Participation participation = controller.participationsRx[index];
                    return Padding(
                        padding: index == controller.participationsRx.length - 1
                            ? const EdgeInsets.only(bottom: 128)
                            : EdgeInsets.zero,
                        child: ListTile(
                          title: Text(participation.name ?? '-'),
                          leading: Text((index + 1).toString()),
                          trailing: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) =>
                                    AlertDialog(
                                      title: Text('Remove Participation'),
                                      content: Text('Are you sure you want to remove "${participation.name}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context), // Cancel
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context); // Close the dialog
                                            ParticipationsRepository.removeParticipation(
                                                controller.id!, participation.id!);
                                          },
                                          child: Text('Remove'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: Icon(Icons.remove),
                          ),
                        )
                    );
                  },
                ),
              ),
    );
  }

  void showEditPollNameDialog(context) {
    final titleController = TextEditingController(text: controller.pollRx.value.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Poll Name"),
          content: TextField(controller: titleController, decoration: InputDecoration(labelText: "Poll Title")),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  controller.pollRx.value.title = title;
                  await PollsRepository.updatePoll(controller.pollRx.value);
                  controller.pollRx.refresh();
                  Get.back();
                }
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void showAddParticipation(context) {
    final titleController = TextEditingController();
    if (controller.participationsRx.length + 1 > 22) {
      showDialog(
        context: context,
        builder:
            (c) =>
            AlertDialog(
              title: Text("Error"),
              content: Text("Total players already 22"),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
            ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Participation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Σημαντικές οδηγίες συμμετοχής:\n\n"
                "• Η συμμετοχή είναι αυστηρή — δεν γίνονται δεκτές ακυρώσεις την τελευταία στιγμή.\n"
                "• Εισάγετε το πλήρες ονοματεπώνυμό σας (όχι ψευδώνυμο).\n"
                "• Παρακαλώ προσέλθετε 15 λεπτά νωρίτερα για ζέσταμα.\n"
                "• Το αντίτιμο να είναι έτοιμο προς εξόφληση στο άτομο που μαζεύει τα χρήματα στο τέλος του αγώνα ή να σταλεί άμεσα μέσω IRIS εκείνη την ώρα.",
              ),
              SizedBox(height: 12),
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Ονοματεπώνυμο"),)
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  await ParticipationsRepository.createParticipation(controller.id!, title);
                  Get.back();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
