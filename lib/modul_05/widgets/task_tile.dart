import 'package:flutter/material.dart';
import '../models/task.dart'; 

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onToggle});

  final Task task;
  final ValueChanged onToggle; // Perbaikan: Tambahkan  di sini

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna = Theme.of(context).colorScheme;
    final DateTime? tanggal = Task.bacaTanggal(task);
    final String tanggalStr = tanggal != null
        ? '({tanggal.day}/){tanggal.month}/${tanggal.year}'
        : '';

    return Card(
      child: CheckboxListTile(
        value: task.done,
        onChanged: (_) => onToggle(task),
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            if (tanggalStr.isNotEmpty) ...[
              Text(
                'Tenggat: $tanggalStr', 
                style: TextStyle(color: warna.outline, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}