import 'dart:io';

import 'package:destask/controller/status_task_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/Beranda/Task/my_date_time_picker.dart';
import 'package:destask/view/Pekerjaan/pekerjaan.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class EditTask extends StatefulWidget {
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late Future<List<dynamic>> statusTask;
  late List<dynamic> status;
  final TextEditingController _deskripsiTaskController =
      TextEditingController();
  final TextEditingController _persentaseSelesaiController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //date picker
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  //file
  PlatformFile? pickedFile;
  File? fileToDisplay;
  String? fileName;
  bool isLoading = false;

  //pick file
  void _pickFile() async {
    setState(() {
      isLoading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
        fileName = pickedFile!.name;
        fileToDisplay = File(pickedFile!.path.toString());
      });
    } else {
      print('User canceled the picker');
    }
    setState(() {
      isLoading = false;
    });
  }

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
        _deskripsiTaskController.text = data['deskripsi_task'] ?? '';
        _selectedDateStart = DateTime.parse(data['tgl_planing']);
        _selectedDateEnd = DateTime.parse(data['tgl_selesai']);
        _persentaseSelesaiController.text = data['persentase_selesai'] ?? '';
        fileName = data['bukti_selesai'] ?? '';
      });
      statusTask = StatusTaskController().getAllStatusTask();
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //deskripsi task
                buildLabel('Deskripsi Task *'),
                buildFormField(_deskripsiTaskController, 'Deskripsi Task',
                    TextInputType.multiline),
                SizedBox(height: 16),

                //tanggal mulai
                buildLabel('Tanggal Mulai *'),
                MyDateTimePicker(
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

                //tanggal selesai
                buildLabel('Tanggal Selesai *'),
                MyDateTimePicker(
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
                //status task
                buildLabel('Status Task *'),
                FutureBuilder<List<dynamic>>(
                  future: statusTask,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error loading data');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No data available');
                    } else {
                      List<dynamic> statusList = snapshot.data!;
                      return buildDropDownMenu(statusList);
                    }
                  },
                ),
                SizedBox(height: 16),
                //persentase selesai
                buildLabel('Persentase Selesai *'),
                buildFormField(_persentaseSelesaiController,
                    'Persentase Selesai', TextInputType.number),
                SizedBox(height: 16),
                //bukti selesai
                buildLabel('Bukti Selesai'),
                GestureDetector(
                  onTap: () {
                    _pickFile();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.upload_file),
                        SizedBox(width: 16),
                        if (pickedFile != null)
                          Expanded(
                            child: Text(
                              fileName!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          Expanded(
                            child: Text(
                              'Pilih file',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {}
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

  DropdownButtonFormField<String> buildDropDownMenu(List<dynamic> statusList) {
    return DropdownButtonFormField<String>(
      value: statusList[0]['nama_status_task'],
      onChanged: (value) {
        // Handle onChanged event
      },
      items: statusList.map((status) {
        return DropdownMenuItem<String>(
          value: status['nama_status_task'],
          child: Text(status['nama_status_task']),
        );
      }).toList(),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kolom Status Task harus diisi';
        }
        return null;
      },
    );
  }

  TextFormField buildFormField(
      TextEditingController controller, String label, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
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
      padding: EdgeInsets.only(bottom: 5),
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
