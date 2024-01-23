import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import 'my_date_time_picker.dart';

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String idpekerjaan;

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
  void initState() {
    super.initState();
    idpekerjaan = Get.parameters['idpekerjaan'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        title: Text('Tambahkan Task', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildLabel('Nama Task'),
                buildFormField(_taskNameController, 'Nama Task'),
                SizedBox(height: 16),
                buildLabel('Detail Task'),
                buildFormField(_taskDetailController, 'Detail Task'),
                SizedBox(height: 16),
                MyDateTimePicker(
                  label: 'Tanggal Mulai',
                  selectedDate: _selectedDateStart,
                  onChanged: (date) {
                    setState(() {
                      _selectedDateStart = date;
                    });
                  },
                  validator: (date) {
                    if (date == null) {
                      return 'Kolom Tanggal Mulai harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                MyDateTimePicker(
                  label: 'Tanggal Selesai',
                  selectedDate: _selectedDateEnd,
                  onChanged: (date) {
                    setState(() {
                      _selectedDateEnd = date;
                    });
                  },
                  validator: (date) {
                    if (date == null) {
                      return 'Kolom Tanggal Selesai harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      // Hanya menjalankan aksi jika formulir valid
                      TaskController taskController = TaskController();
                      bool addedSuccessfully = await taskController.addTask(
                        idpekerjaan,
                        _taskNameController.text,
                        _taskDetailController.text,
                        _selectedDateStart ?? DateTime.now(),
                        _selectedDateEnd ?? DateTime.now(),
                      );

                      if (addedSuccessfully) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Task Berhasil Ditambahkan',
                        );
                      } else {
                        //stay on the same page
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GlobalColors.mainColor,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Simpan',
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
        ),
      ),
    );
  }

  TextFormField buildFormField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kolom $label harus diisi';
        }
        return null;
      },
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
}
