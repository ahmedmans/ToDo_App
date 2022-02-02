import 'package:todo_app/app/data/models/task.dart';
import 'package:todo_app/app/data/providers/task/provider.dart';

class Repository {
  TaskProvider taskProvider;
  Repository({required this.taskProvider});

  List<Task> readTasks() => taskProvider.displayTasks();
  void writeTasks(List<Task> tasks) => taskProvider.addTasks(tasks);
}
