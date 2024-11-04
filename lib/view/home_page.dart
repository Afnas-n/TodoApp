import 'package:flutter/material.dart';
import 'package:todo_app/Model/task_model.dart';
import 'package:todo_app/Services/database_helper.dart';
import 'package:todo_app/view/field_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<TaskModel>?> taskList;

  @override
  void initState() {
    super.initState();
    taskList = DatabaseHelper().getTasks(); // Initialize task list
  }

  Future<void> refreshTaskList() async {
    setState(() {
      taskList = DatabaseHelper().getTasks(); // Refresh task list after deletion or adding
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text("TODO"),
      ),
      body: FutureBuilder<List<TaskModel>?>(
        future: taskList, // Fetch tasks
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading tasks'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks added yet'));
          } else {
            List<TaskModel> tasks = snapshot.data!;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                TaskModel task = tasks[index];
                return ListTile(
                  title: Text(task.task),
                  subtitle: Text(
                      'Due: ${task.getFormattedDate()} at ${task.getFormattedTime(context)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await DatabaseHelper().deleteTask(task.id!);
                      await refreshTaskList(); // Refresh the UI after deletion
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => const FieldPage()));
            await refreshTaskList(); // Refresh UI after returning from FieldPage
          },
          backgroundColor: Colors.green[400],
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
