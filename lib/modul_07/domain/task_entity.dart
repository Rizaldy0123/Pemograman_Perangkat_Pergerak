class TaskEntity {
  final String id;
  final String title;
  final bool isCompleted;

  const TaskEntity({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  TaskEntity copyWith({String? id, String? title, bool? isCompleted}) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskFailure {
  final String message;
  const TaskFailure(this.message);
}

abstract class TaskRepository {
  List<TaskEntity> getAllTasks();
  void addTask(TaskEntity task);
  void toggleTask(String id);
}
