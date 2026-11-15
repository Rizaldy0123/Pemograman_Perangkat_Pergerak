import 'package:flutter/material.dart';

import '../presentation/task_viewmodel.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatefulWidget {
  final TaskViewModel viewModel;
  const TaskListScreen({super.key, required this.viewModel});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas (Modul 07 – Fase A)')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Tulis tugas baru...',
                          errorText: widget.viewModel.failure?.message,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        widget.viewModel.createTask(_controller.text);
                        if (widget.viewModel.failure == null) {
                          _controller.clear();
                        }
                      },
                      child: const Text('Tambah'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.viewModel.tasks.length,
                  itemBuilder: (context, index) {
                    final task = widget.viewModel.tasks[index];
                    return TaskCard(
                      task: task,
                      onToggle: () =>
                          widget.viewModel.toggleTaskStatus(task.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
