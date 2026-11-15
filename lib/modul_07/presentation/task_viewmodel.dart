import 'package:flutter/foundation.dart';

import '../domain/task_entity.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;
  TaskFailure? _failure;

  TaskViewModel(this._repository);

  List<TaskEntity> get tasks => _repository.getAllTasks();
  TaskFailure? get failure => _failure;

  void createTask(String rawTitle) {
    final title = rawTitle.trim();
    if (title.isEmpty) {
      _failure = const TaskFailure('Judul tugas tidak boleh kosong');
      notifyListeners();
      return;
    }

    _failure = null;
    _repository.addTask(
      TaskEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      ),
    );
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    _repository.toggleTask(id);
    notifyListeners();
  }
}
