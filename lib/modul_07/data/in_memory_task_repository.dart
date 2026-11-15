import '../domain/task_entity.dart';

class InMemoryTaskRepository implements TaskRepository {
  final List<TaskEntity> _storage = [];

  @override
  List<TaskEntity> getAllTasks() => List.unmodifiable(_storage);

  @override
  void addTask(TaskEntity task) {
    _storage.add(task);
  }

  @override
  void toggleTask(String id) {
    final index = _storage.indexWhere((item) => item.id == id);
    if (index != -1) {
      _storage[index] = _storage[index].copyWith(
        isCompleted: !_storage[index].isCompleted,
      );
    }
  }
}
