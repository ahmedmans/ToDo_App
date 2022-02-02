import 'dart:convert';

import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/keys.dart';
import 'package:todo_app/app/data/models/task.dart';
import 'package:todo_app/app/data/services/storage/services.dart';

class TaskProvider {
  final StorageServices _services = Get.find<StorageServices>();

  List<Task> displayTasks() {
    var taskData = <Task>[];

    jsonDecode(_services.read(taskKey).toString())
        .forEach((data) => taskData.add(Task.fromeJson(data)));
    return taskData;
  }

  void addTasks(List<Task> tasks) {
    _services.write(taskKey, jsonEncode(tasks));
  }
}
