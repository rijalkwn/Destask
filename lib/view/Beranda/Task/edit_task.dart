import 'dart:io';
import 'package:destask/controller/hari_libur_controller.dart';
import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:intl/intl.dart';
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
  HariLiburController hariLiburController = HariLiburController();
  String idUser = "";
  String idpm = "";
  String namafoto = '';
  bool isLoading = false;
  String idPekerjaan = "";
  String namaPekerjaan = "";
  String namaKategori = "";
  String creator = "";
  String id_user_login = '';
  DateTime targetWaktuSelesai = DateTime.now();
  DateTime tanggalMulai = DateTime.now();
  DateTime today = DateTime.now();
  List<DateTime> listTanggalLibur = [];

  // String idStatusTask = "";
  String idKategoriTask = "";
  bool completed = false;
  List<StatusTaskModel> statusList = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  refresh() async {
    setState(() {
      loadData();
    });
  }

  getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    setState(() {
      id_user_login = idUser.toString();
    });
    print('login: $id_user_login');

    return idUser;
  }

  //hari libur
  Future<List<DateTime>> listHariLibur() async {
    var data = await hariLiburController.getAllHariLibur();

    // Ensure that tanggal_libur is explicitly cast to DateTime
    List<DateTime> tanggalLibur = data.map<DateTime>((hariLibur) {
      // Example: Assuming tanggal_libur is already DateTime, ensure the correct access
      return DateTime.parse(hariLibur.tanggal_libur.toString());
    }).toList();

    setState(() {
      listTanggalLibur.addAll(tanggalLibur);
    });
    return listTanggalLibur;
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  void loadData() async {
    try {
      listHariLibur();
      getDataKategoriTask();
      getIdUser();
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
          namaKategori = value[0].data_tambahan.nama_kategori_task.toString();
        });
        print('cre: $creator');
        pekerjaanController.getPekerjaanById(idPekerjaan).then((value) {
          setState(() {
            targetWaktuSelesai = value[0].target_waktu_selesai;
            tanggalMulai = value[0].created_at;
            idpm = value[0].data_tambahan.project_manager[0].id_user;
          });
          print('idpm: $idpm');
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

  //getkategori task
  Future<List<KategoriTaskModel>> getDataKategoriTask() async {
    List<KategoriTaskModel> dataKategori =
        await kategoriTaskController.getAllKategoriTask();
    return dataKategori;
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
                    formDisabled(namaPekerjaan),
                    const SizedBox(height: 16),
                    //pm atau creator
                    idpm == id_user_login || id_user_login == creator
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildLabel('Deskripsi Task *'),
                              buildFormField(_deskripsiTaskController,
                                  'Deskripsi Task', TextInputType.multiline),
                              const SizedBox(height: 16),
                              buildLabel('Target Waktu Selesai *'),
                              MyDateTimePicker(
                                selectedDate: _selectedDateStart,
                                onChanged: (date) {
                                  setState(() {
                                    _selectedDateStart = date;
                                  });
                                },
                                validator: (date) {
                                  if (date == null) {
                                    return 'Kolom Tanggal Target Waktu Selesai harus diisi';
                                  } else if (date.isAfter(targetWaktuSelesai)) {
                                    return 'Tanggal melebihi target waktu selesai pekerjaan';
                                  } else if (_isWeekend(date)) {
                                    return 'Tanggal tidak boleh jatuh pada hari Sabtu atau Minggu';
                                  } else if (listTanggalLibur.contains(date)) {
                                    return 'Tanggal yang dipilih adalah hari libur';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              //kategori task
                              buildLabel('Kategori Task *'),
                              FutureBuilder<List<KategoriTaskModel>>(
                                future: getDataKategoriTask(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Gagal memuat data, Silakan tekan tombol refresh untuk mencoba lagi.',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              refresh();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.refresh,
                                                    color: Colors.white,
                                                  ),
                                                  const Text(
                                                    'Refresh',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Text(
                                        'Data Kategori Task tidak ditemukan');
                                  } else {
                                    List<KategoriTaskModel> kategoriList =
                                        snapshot.data!;
                                    return DropdownButtonFormField<String>(
                                      value: idKategoriTask,
                                      onChanged: (value) {
                                        setState(() {
                                          idKategoriTask = value!;
                                        });
                                        print(
                                            'idKategoriTask: $idKategoriTask');
                                      },
                                      items: kategoriList.map((kategori) {
                                        return DropdownMenuItem<String>(
                                          value: kategori.id_kategori_task,
                                          child: Text(kategori
                                              .nama_kategori_task
                                              .toString()),
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
                                    );
                                  }
                                },
                              ),
                              // idKategoriTask == ""
                              //     ? const Text("Memuat data")
                              //     : DropdownButtonFormField<String>(
                              //         value: idKategoriTask,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             idKategoriTask = value!;
                              //           });
                              //         },
                              //         items: kategoriList.map((kategori) {
                              //           return DropdownMenuItem<String>(
                              //             value: kategori.id_kategori_task,
                              //             child: Text(kategori
                              //                 .nama_kategori_task
                              //                 .toString()),
                              //           );
                              //         }).toList(),
                              //         decoration: const InputDecoration(
                              //           contentPadding: EdgeInsets.symmetric(
                              //               horizontal: 15, vertical: 3),
                              //           border: OutlineInputBorder(),
                              //         ),
                              //         validator: (value) {
                              //           if (value == null || value.isEmpty) {
                              //             return 'Kolom Kategori Task harus diisi';
                              //           }
                              //           return null;
                              //         },
                              //       ),
                              //persentase selesai
                              buildLabel('Persentase Selesai *'),
                              buildFormFieldPersentase(
                                  _persentaseSelesaiController,
                                  'Persentase Selesai',
                                  TextInputType.number),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildLabel('Deskripsi Task *'),
                              formDisabled(_deskripsiTaskController.text),
                              const SizedBox(height: 16),
                              buildLabel('Target Waktu Selesai *'),
                              //tampilan target waktu selesai yang tidak bisa diubah
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Row(
                                  children: [
                                    //icon tanggal
                                    Icon(Icons.calendar_today,
                                        color: Colors.grey, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      formatDate(targetWaktuSelesai),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              buildLabel('Kategori Task *'),
                              formDisabled(namaKategori),
                              const SizedBox(height: 16),
                              buildLabel('Persentase Selesai *'),
                              buildFormFieldPersentase(
                                  _persentaseSelesaiController,
                                  'Persentase Selesai',
                                  TextInputType.number),
                            ],
                          ),
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
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Simpan',
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

  Container formDisabled(String nama) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Text(
        nama,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
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

  //format date
  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }
}
