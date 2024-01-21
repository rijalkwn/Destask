import 'package:destask/controller/task_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/Beranda/Task/my_date_time_picker.dart';
import 'package:destask/view/Pekerjaan/pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTask extends StatefulWidget {
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailController = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

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

  Future<Map<String, dynamic>> fetchData() async {
    final String idTask = Get.parameters['idtask'] ?? '';
    TaskController taskController = TaskController();
    Map<String, dynamic> task = await taskController.getTaskById(idTask);
    return task;
  }

  var idPekerjaan = null;

  @override
  void initState() {
    super.initState();
    fetchData().then((data) {
      setState(() {
        idPekerjaan = data['idpekerjaan'] ?? '';
        _taskNameController.text = data['nama_task'] ?? '';
        _taskDetailController.text = data['detail_task'] ?? '';
        _selectedDateStart = DateTime.parse(data['tanggal_mulai'] ?? '');
        _selectedDateEnd = DateTime.parse(data['tanggal_selesai'] ?? '');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String idTask = Get.parameters['idtask'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _keyForm,
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
                    TaskController taskController = TaskController();

                    bool addedSuccessfully = await taskController.editTask(
                      idPekerjaan,
                      idTask,
                      _taskNameController.text,
                      _taskDetailController.text,
                      _selectedDateStart ?? DateTime.now(),
                      _selectedDateEnd ?? DateTime.now(),
                    );

                    if (addedSuccessfully) {
                      Get.offAndToNamed('/task/$idPekerjaan');
                    } else {
                      print('Error adding task');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GlobalColors.mainColor,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Update',
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
