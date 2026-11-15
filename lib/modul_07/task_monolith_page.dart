import 'package:flutter/material.dart';

class TaskMonolithPage extends StatefulWidget {
  const TaskMonolithPage({super.key});

  @override
  State<TaskMonolithPage> createState() => _TaskMonolithPageState();
}

class _TaskMonolithPageState extends State<TaskMonolithPage> {
  final List> _tasks = [];
  final TextEditingController _titleController = TextEditingController();

  void _submitTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      _tasks.add({
        'id': DateTime.now().toString(),
        'title': title,
        'isDone': false,
      });
      _titleController.clear();
    });
  }

  void _toggleDone(int index) {
    setState(() {
      _tasks[index]['isDone'] = !_tasks[index]['isDone'];
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas (Non-Arsitektur)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _titleController)),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submitTask,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: CheckboxListTile(
                  title: Text(_tasks[index]['title']),
                  value: _tasks[index]['isDone'],
                  onChanged: (_) => _toggleDone(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}