import 'dart:io';
import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/kategori_task_controller.dart';
import '../../../controller/task_controller.dart';
import '../../../model/kategori_task_model.dart';
import 'package:quickalert/quickalert.dart';
import '../../../controller/status_task_controller.dart';
import '../../../model/status_task_model.dart';
import '../../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_date_time_picker.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final String idTask = Get.parameters['idtask'] ?? '';
  final TextEditingController _deskripsiTaskController =
      TextEditingController();
  final TextEditingController _persentaseSelesaiController =
      TextEditingController();
  final TextEditingController _tautanTaskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StatusTaskController statusTaskController = StatusTaskController();
  KategoriTaskController kategoriTaskController = KategoriTaskController();
  TaskController taskController = TaskController();
  PekerjaanController pekerjaanController = PekerjaanController();
  File? _image;
  String idUser = "";
  String namafoto = '';
  bool isLoading = false;
  String idPekerjaan = "";
  String namaPekerjaan = "";
  String creator = "";
  DateTime targetWaktuSelesai = DateTime.now();
  DateTime tanggalMulai = DateTime.now();
  // String idStatusTask = "";
  String idKategoriTask = "";
  bool completed = false;
  List<StatusTaskModel> statusList = [];
  List<KategoriTaskModel> kategoriList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      // statusList = await statusTaskController.showAll();
      kategoriList = await kategoriTaskController.showAll();
      taskController.showById(idTask).then((value) {
        setState(() {
          idPekerjaan = value[0].id_pekerjaan.toString();
          idUser = value[0].id_user.toString();
          creator = value[0].creator.toString();
          _deskripsiTaskController.text = value[0].deskripsi_task.toString();
          _persentaseSelesaiController.text =
              value[0].persentase_selesai.toString();
          _selectedDateStart = DateTime.parse(value[0].tgl_planing.toString());
          // idStatusTask = value[0].id_status_task.toString();
          idKategoriTask = value[0].id_kategori_task.toString();
          // _tautanTaskController.text = value[0].tautan_task.toString();
          _persentaseSelesaiController.text =
              value[0].persentase_selesai.toString();
          namaPekerjaan = value[0].data_tambahan.nama_pekerjaan.toString();
        });
        pekerjaanController.getPekerjaanById(idPekerjaan).then((value) {
          setState(() {
            targetWaktuSelesai = value[0].target_waktu_selesai;
            tanggalMulai = value[0].created_at;
          });
        });
        return value;
      });
    } catch (e) {
      print('Error loading data: $e');
      QuickAlert.show(
        context: context,
        title: "Gagal Memuat Data",
        type: QuickAlertType.error,
      );
    }
  }

  //date picker
  DateTime? _selectedDateStart;

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

  @override
  void dispose() {
    _deskripsiTaskController.dispose();
    _persentaseSelesaiController.dispose();
    _tautanTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        title: const Text('Edit Task', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildLabel('Pekejaan *'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Text(
                        namaPekerjaan,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Deskripsi Task *'),
                    buildFormField(_deskripsiTaskController, 'Deskripsi Task',
                        TextInputType.multiline),
                    const SizedBox(height: 16),

                    //tanggal mulai
                    creator == idUser
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildLabel('Deadline *'),
                              MyDateTimePicker(
                                selectedDate: _selectedDateStart,
                                onChanged: (date) {
                                  setState(() {
                                    _selectedDateStart = date;
                                  });
                                },
                                validator: (date) {
                                  if (date == null) {
                                    return 'Kolom Tanggal Deadline harus diisi';
                                  } else if (date.isBefore(tanggalMulai)) {
                                    return 'Tanggal tidak boleh sebelum tanggal mulai';
                                  } else if (date.isAfter(targetWaktuSelesai)) {
                                    return 'Tanggal melebihi target waktu selesai';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox(),
                    //status task
                    // buildLabel('Status Task *'),
                    // idStatusTask == ""
                    //     ? const Text("Memuat data")
                    //     : DropdownButtonFormField<String>(
                    //         value: idStatusTask,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             idStatusTask = value!;
                    //           });
                    //         },
                    //         items: statusList.map((status) {
                    //           return DropdownMenuItem<String>(
                    //             value: status.id_status_task,
                    //             child: Text(status.nama_status_task.toString()),
                    //           );
                    //         }).toList(),
                    //         decoration: const InputDecoration(
                    //           contentPadding: EdgeInsets.symmetric(
                    //               horizontal: 15, vertical: 3),
                    //           border: OutlineInputBorder(),
                    //         ),
                    //         validator: (value) {
                    //           if (value == null || value.isEmpty) {
                    //             return 'Kolom Status Task harus diisi';
                    //           }
                    //           return null;
                    //         },
                    //       ),
                    // const SizedBox(height: 16),
                    //kategori task
                    buildLabel('Kategori Task *'),
                    idKategoriTask == ""
                        ? const Text("Memuat data")
                        : DropdownButtonFormField<String>(
                            value: idKategoriTask,
                            onChanged: (value) {
                              setState(() {
                                idKategoriTask = value!;
                              });
                            },
                            items: kategoriList.map((kategori) {
                              return DropdownMenuItem<String>(
                                value: kategori.id_kategori_task,
                                child: Text(
                                    kategori.nama_kategori_task.toString()),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 3),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kolom Kategori Task harus diisi';
                              }
                              return null;
                            },
                          ),
                    const SizedBox(height: 16),
                    //persentase selesai
                    buildLabel('Persentase Selesai *'),
                    buildFormFieldPersentase(_persentaseSelesaiController,
                        'Persentase Selesai', TextInputType.number),
                    const SizedBox(height: 5),
                  ],
                ),
                const SizedBox(height: 16),

                //button
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      bool editTask = await taskController.editTask(
                        idTask.toString(),
                        idPekerjaan.toString(),
                        idKategoriTask,
                        _selectedDateStart!, //tgl planing
                        _deskripsiTaskController.text,
                        _persentaseSelesaiController.text.toString(),
                      );
                      if (editTask) {
                        Get.offAndToNamed('/task/$idPekerjaan');
                        QuickAlert.show(
                            context: context,
                            title: "Edit Task Berhasil",
                            type: QuickAlertType.success);
                      } else {
                        QuickAlert.show(
                            context: context,
                            title: "Edit Task Gagal",
                            type: QuickAlertType.error);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Edit Task',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildFormField(
      TextEditingController controller, String label, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: const InputDecoration(
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

  TextFormField buildFormFieldPersentase(
      TextEditingController controller, String label, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
        suffixText: '%', // Tambahkan simbol % di ujung kanan
        suffixStyle: const TextStyle(fontSize: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kolom $label harus diisi';
        }
        int? val = int.tryParse(value);
        if (val == null || val < 0 || val > 100) {
          return 'Nilai harus antara 0 dan 100';
        }
        return null;
      },
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextFormField buildFormFieldBolehKosong(
      TextEditingController controller, String label, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
      ),
    );
  }
}
