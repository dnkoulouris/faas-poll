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
                    return ListTile(
                      title: Text(participation.name ?? '-'),
                      leading: Text((index + 1).toString()),
                      trailing: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
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
                                      controller.id!,
                                      participation.id!,
                                    );
                                  },
                                  child: Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(Icons.remove),
                      ),
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Participation"),
          content: TextField(controller: titleController, decoration: InputDecoration(labelText: "Name")),
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
