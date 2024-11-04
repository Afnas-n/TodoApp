import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskModel {
  int? id;
  String task;
  DateTime selectedDate;
  TimeOfDay selectedTime;

  TaskModel({
    this.id,
    required this.task,
    required this.selectedDate,
    required this.selectedTime,
  });

  // Format the date as 'dd/MM/yyyy'
  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  // Format the time using the TimeOfDay's format method
  String getFormattedTime(BuildContext context) {
    return selectedTime.format(context);
  }

  // Convert TaskModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'selectedDate': selectedDate.toIso8601String(),
      'selectedTime': '${selectedTime.hour}:${selectedTime.minute}',
    };
  }

  // Convert JSON to TaskModel
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      task: json['task'],
      selectedDate: DateTime.parse(json['selectedDate']),
      selectedTime: TimeOfDay(
        hour: int.parse(json['selectedTime'].split(':')[0]),
        minute: int.parse(json['selectedTime'].split(':')[1]),
      ),
    );
  }
}
