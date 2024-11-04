import 'package:flutter/material.dart';

class DatePickerApp extends StatefulWidget {
  const DatePickerApp({super.key});

  @override
  State<DatePickerApp> createState() => _DatePickerAppState();
}

class _DatePickerAppState extends State<DatePickerApp> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());

  // ignore: non_constant_identifier_names
  // void PickDate() async {
  //   selectedDate = await showDatePicker(
  //       context: context, firstDate: DateTime.now(), lastDate: DateTime(2026));
  //   log(selectedDate.toString());
  // }

  // ignore: non_constant_identifier_names
  // void PickTime() async {
  //   selectTime =
  //       await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //   log(selectTime.toString());
  // }

  Future selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2222));
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      print(picked);
    } else {
      print(picked);
    }
  }

  Future selectTime(BuildContext context) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != selectTime) {
      setState(() => selectedTime = picked);
      print(picked);
    } else {
      print(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 200),
            TextButton(
              onPressed: () {
                selectDate(context);
              },
              child: const Text("pick date"),
            ),
            Text(selectedDate.toString().split(" ").first),
            TextButton(
                onPressed: () {
                  selectTime(context);
                },
                child: const Text("Pickdate")),
            Text(selectedTime.toString())
          ],
        ),
      ),
    );
  }
}
