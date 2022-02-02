import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/data/models/task.dart';

import 'package:todo_app/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  Repository repository;
  HomeController({
    required this.repository,
  });
  final formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  final chipIndex = 0.obs;
  final tabIndex = 0.obs;
  final tasksList = <Task>[].obs;
  final deleting = false.obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final completedTodos = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasksList.assignAll(repository.readTasks());
    ever(tasksList, (_) => repository.writeTasks(tasksList));
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeliting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? select) {
    task.value = select;
  }

  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    completedTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];

      if (status == true) {
        completedTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTask(Task task) {
    if (tasksList.contains(task)) {
      return false;
    }
    tasksList.add(task);
    return true;
  }

  void deleteTask(Task task) {
    tasksList.remove(task);
  }

  updateTask(Task task, String title) {
    var todos = task.todos ?? [];
    if (containeTodo(todos, title)) {
      return false;
    }
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIndex = tasksList.indexOf(task);
    tasksList[oldIndex] = newTask;
    tasksList.refresh();
    textEditingController.clear();
    return true;
  }

  bool containeTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  bool addTodo(String title) {
    var todo = {'title': title, 'done': false};
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    var doneTodo = {'title': title, 'done': true};
    if (completedTodos
        .any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...completedTodos,
    ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIndex = tasksList.indexOf(task.value);
    tasksList[oldIndex] = newTask;
    tasksList.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {'title': title, 'done': true};
    completedTodos.add(doneTodo);
    doingTodos.refresh();
    completedTodos.refresh();
  }

  void deletDoneTodo(dynamic doneTodo) {
    int index = completedTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    completedTodos.removeAt(index);
    completedTodos.refresh();
  }

  bool isTodosEmpyt(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

  int getTotalTask() {
    var res = 0;
    for (int i = 0; i < tasksList.length; i++) {
      if (tasksList[i].todos != null) {
        res += tasksList[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalCompleteTask() {
    var res = 0;
    for (int i = 0; i < tasksList.length; i++) {
      if (tasksList[i].todos != null) {
        for (int d = 0; d < tasksList[i].todos!.length; d++) {
          if (tasksList[i].todos![d]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
