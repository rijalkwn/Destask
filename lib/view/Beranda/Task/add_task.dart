import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/hari_libur_controller.dart';
import 'package:destask/model/pekerjaan_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/kategori_task_controller.dart';
import '../../../controller/task_controller.dart';
import '../../../model/kategori_task_model.dart';
import 'package:quickalert/quickalert.dart';
import '../../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_date_time_picker.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final String idpekerjaan = Get.parameters['idpekerjaan'] ?? '';
  final TextEditingController _deskripsiTaskController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  KategoriTaskController kategoriTaskController = KategoriTaskController();
  TaskController taskController = TaskController();
  PekerjaanController pekerjaanController = PekerjaanController();
  HariLiburController hariLiburController = HariLiburController();

  bool isLoading = false;
  String idUser = "";
  String idanggotauser = "";
  String idKategoriTask = "1";
  String namaPekerjaan = "";
  bool cekPM = false;
  bool cekBobot = false;
  String PM = "";
  DateTime targetWaktuSelesai = DateTime.now();
  DateTime tanggalMulai = DateTime.now();
  DateTime today = DateTime.now();
  List<DateTime> listTanggalLibur = [];

  @override
  void initState() {
    super.initState();
    getDataPekerjaan();
    cekuserPM();
    getDataKategoriTask();
    listPersonil();
    listHariLibur();
  }

  refresh() async {
    setState(() {
      getDataPekerjaan();
      cekuserPM();
      getDataKategoriTask();
      listPersonil();
      listHariLibur();
    });
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

    print(listTanggalLibur);
    return listTanggalLibur;
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  Future getDataPekerjaan() async {
    List<PekerjaanModel> dataPekerjaan =
        await pekerjaanController.getPekerjaanById(idpekerjaan);
    setState(() {
      targetWaktuSelesai = dataPekerjaan[0].target_waktu_selesai;
      tanggalMulai = dataPekerjaan[0].created_at;
    });
  }

  Future listPersonil() async {
    List listpersonil =
        await pekerjaanController.listPersonilPekerjaan(idpekerjaan);
    return listpersonil;
  }

  cekuserPM() async {
    List<PekerjaanModel> dataPekerjaan =
        await pekerjaanController.getPekerjaanById(idpekerjaan);
    setState(() {
      namaPekerjaan = dataPekerjaan[0].nama_pekerjaan;
      PM = dataPekerjaan[0].data_tambahan.project_manager[0].id_user;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString('id_user') ?? '';
    if (PM == idUser) {
      setState(() {
        cekPM = true;
      });
    } else {
      setState(() {
        idanggotauser = idUser;
      });
      print("iduser" + idUser);
    }
  }

  //getkategori task
  Future<List<KategoriTaskModel>> getDataKategoriTask() async {
    List<KategoriTaskModel> dataKategori =
        await kategoriTaskController.getAllKategoriTask();
    return dataKategori;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        title:
            const Text('Tambahkan Task', style: TextStyle(color: Colors.white)),
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
                //nama pekerjaan
                buildLabel('Nama Pekerjaan'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    namaPekerjaan,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                //deskripsi task
                buildLabel('Deskripsi Task *'),
                buildFormField(_deskripsiTaskController, 'Deskripsi Task',
                    TextInputType.multiline),
                const SizedBox(height: 16),

                //tanggal mulai
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
                    } else if (date
                        .isBefore(tanggalMulai.subtract(Duration(days: 1)))) {
                      return 'Tanggal tidak boleh sebelum tanggal mulai';
                    } else if (date.isAfter(targetWaktuSelesai)) {
                      return 'Tanggal melebihi target waktu selesai';
                    } else if (date
                        .isBefore(today.subtract(Duration(days: 1)))) {
                      return 'Tanggal tidak boleh sebelum hari ini';
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Data Kategori Task tidak ditemukan');
                    } else {
                      List<KategoriTaskModel> kategoriList = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        value: idKategoriTask,
                        onChanged: (value) {
                          setState(() {
                            idKategoriTask = value!;
                          });
                          print('idKategoriTask: $idKategoriTask');
                        },
                        items: kategoriList.map((kategori) {
                          return DropdownMenuItem<String>(
                            value: kategori.id_kategori_task,
                            child: Text(kategori.nama_kategori_task.toString()),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 3),
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
                const SizedBox(height: 16),

                //autor
                cekPM
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildLabel('Pilih Personil *'),
                          FutureBuilder(
                            future:
                                listPersonil(), // Replace 'idpekerjaan' with your actual job ID
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              } else if (snapshot.hasData) {
                                List<Map<String, dynamic>> picList =
                                    snapshot.data as List<Map<String, dynamic>>;
                                return DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                  ),
                                  items: picList
                                      .map((e) =>
                                          '${e['nama']} - ${e['role_personil']}')
                                      .toList(),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: "Pilih Personil *",
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      idanggotauser = picList
                                          .firstWhere((element) =>
                                              '${element['nama']} - ${element['role_personil']}' ==
                                              value)['id_user']
                                          .toString();
                                    });
                                  },
                                  selectedItem: idanggotauser != ''
                                      ? '${picList.firstWhere((element) => element['id_user'].toString() == idanggotauser)['nama']} - ${picList.firstWhere((element) => element['id_user'].toString() == idanggotauser)['role_personil']}'
                                      : null,
                                );
                              } else {
                                return Text('Data not available');
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    : Container(),
                //simpan
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      bool addTask = await taskController.addTask(
                        idpekerjaan,
                        idanggotauser,
                        idKategoriTask,
                        _selectedDateStart!, //tgl planing
                        _deskripsiTaskController.text,
                      );
                      if (addTask) {
                        Navigator.pushReplacementNamed(
                            context, '/task/$idpekerjaan');
                        QuickAlert.show(
                            context: context,
                            title: "Tambah Task Berhasil",
                            type: QuickAlertType.success);
                      } else {
                        QuickAlert.show(
                            context: context,
                            title: "Tambah Task Gagal",
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GlobalColors.mainColor,
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
                ),
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
}
