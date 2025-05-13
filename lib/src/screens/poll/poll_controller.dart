import 'dart:async';

import 'package:football_as_a_service/src/model/participation.dart';
import 'package:football_as_a_service/src/repository/participations_repository.dart';
import 'package:football_as_a_service/src/repository/polls_repository.dart';
import 'package:get/get.dart';

import '../../model/poll.dart';

class PollController extends GetxController {
  final Rx<Poll> pollRx = Poll().obs;
  final id = Get.parameters["id"];
  final RxList<Participation> participationsRx = <Participation>[].obs;
  StreamSubscription? _participationsSub;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    pollRx.value = (await PollsRepository.getPoll(id ?? ''))!;
    _participationsSub = ParticipationsRepository.listen(id!).listen((list) {
      list.sort((p1, p2) => p1.createdAt!.compareTo(p2.createdAt!));
      participationsRx.value = list;
    });
  }

  @override
  void onClose() {
    _participationsSub?.cancel();
    super.onClose();
  }
}
