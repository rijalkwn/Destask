import 'package:destask/controller/task_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailController = TextEditingController();

  //date picker
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateStart ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDateStart) {
      setState(() {
        _selectedDateStart = pickedDate;
      });
    }
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateEnd ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDateEnd) {
      setState(() {
        _selectedDateEnd = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String idpekerjaan = Get.parameters['idpekerjaan'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildLabel('Nama Task'),
            buildFormField(_taskNameController),
            SizedBox(height: 16),
            buildLabel('Detail Task'),
            buildFormField(_taskDetailController),
            SizedBox(height: 16),
            buildDateTimePicker(
              label: 'Tanggal Mulai',
              selectedDate: _selectedDateStart,
              onTap: () => _selectDateStart(context),
            ),
            buildDateTimePicker(
              label: 'Tanggal Selesai',
              selectedDate: _selectedDateEnd,
              onTap: () => _selectDateEnd(context),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () async {
                TaskController taskController = TaskController();

                bool addedSuccessfully = await taskController.addTask(
                  idpekerjaan, // Replace with the actual ID pekerjaan
                  _taskNameController.text,
                  _taskDetailController.text,
                  _selectedDateStart ?? DateTime.now(),
                  _selectedDateEnd ?? DateTime.now(),
                );

                if (addedSuccessfully) {
                  Get.toNamed('task'); // Kembali ke halaman sebelumnya
                } else {
                  //stay on the same page
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GlobalColors.mainColor,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tambahkan Task',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildFormField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDateTimePicker({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(label),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  selectedDate != null
                      ? '${selectedDate.toLocal()}'.split(' ')[0]
                      : 'No date selected',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            MaterialButton(
              onPressed: onTap,
              child: Icon(Icons.calendar_today),
            ),
          ],
        ),
      ],
    );
  }
}
