import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key, required this.callback});

  final TextEditingController _controller = TextEditingController();

  final Function(String) callback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              label: Text("Task name"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String name = _controller.text;
          callback(name);
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
