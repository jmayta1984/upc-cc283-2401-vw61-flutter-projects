import 'package:flutter/material.dart';
import 'package:to_do/screens/task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List tasks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To Do"),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(task: tasks[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskScreen(
                  callback: (name) {
                    tasks.add(name);
                    setState(() {
                      tasks = tasks;
                    });
                  },
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.task});

  final String task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.task),
      trailing: Checkbox(
        onChanged: (value) {
          setState(() {
            isChecked = value!;
          });
        },
        value: isChecked,
      ),
    );
  }
}
