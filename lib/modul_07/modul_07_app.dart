import 'package:flutter/material.dart';

import 'data/in_memory_task_repository.dart';
import 'presentation/task_viewmodel.dart';
import 'screens/task_list_screen.dart';

class Modul07App extends StatefulWidget {
  const Modul07App({super.key});

  @override
  State<Modul07App> createState() => _Modul07AppState();
}

class _Modul07AppState extends State<Modul07App> {
  late final TaskViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final repository = InMemoryTaskRepository();
    _viewModel = TaskViewModel(repository);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskListScreen(viewModel: _viewModel),
    );
  }
}
