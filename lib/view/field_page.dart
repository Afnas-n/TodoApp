import 'package:flutter/material.dart';
import 'package:todo_app/Model/task_model.dart';
import 'package:todo_app/Services/database_helper.dart';
import 'package:intl/intl.dart';

class FieldPage extends StatefulWidget {
  const FieldPage({super.key});

  @override
  State<FieldPage> createState() => _FieldPageState();
}

class _FieldPageState extends State<FieldPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController taskController = TextEditingController();
  final dbHelper = DatabaseHelper();

  Future<void> saveTask() async {
    if (taskController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task')),
      );
      return;
    }

    TaskModel newTask = TaskModel(
      task: taskController.text,
      selectedDate: selectedDate,
      selectedTime: selectedTime,
    );

    await dbHelper.insertTask(newTask);

    // Clear the text field and reset date/time to defaults
    taskController.clear();
    setState(() {
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    });

    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task is saved')),
    );
  }

  Future selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2222),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    String formattedTime = selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("What is to be done"),
              TextFormField(
                controller: taskController,
                decoration: const InputDecoration(hintText: "Enter Task Here"),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formattedDate),
                  IconButton(
                    onPressed: () => selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formattedTime),
                  IconButton(
                    onPressed: () => selectTime(context),
                    icon: const Icon(Icons.access_time),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Center(
                child: SizedBox(
                  height: 40,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      saveTask();
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
