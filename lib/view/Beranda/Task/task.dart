import 'package:destask/controller/bobot_kategori_task_controller.dart';
import 'package:destask/controller/target_poin_harian_controller.dart';
import 'package:destask/controller/user_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:intl/intl.dart';
import '../../../controller/pekerjaan_controller.dart';
import '../../../controller/task_controller.dart';
import '../../../model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
  TextEditingController searchController = TextEditingController();
  PekerjaanController pekerjaanController = PekerjaanController();
  TaskController taskController = TaskController();
  UserController userController = UserController();
  BobotKategoriTaskController bobotKategoriTaskController =
      BobotKategoriTaskController();
  TargetPoinHarianController targetPoinHarianController =
      TargetPoinHarianController();
  bool isSearchBarVisible = false;
  bool cekBobotKategoriTaskPM = false;
  bool cekTargetPoinPM = false;
  bool cekBobotKategoriTaskIndividu = false;
  bool cekTargetPoinIndividu = false;
  String namaPekerjaan = '';
  String idStatusPekerjaan = '';
  String statusTaskValue = 'Status'; //server
  String dropdownValue = 'Semua';
  String userValue = 'Personil';
  String iduser = '';
  String idpm = '';

  //pm
  bool isPM = false;

  late Future<List<TaskModel>> task;
  late Future<List> user;

  @override
  void initState() {
    super.initState();
    task = getDataTask();
    getIdUser();
    getPekerjaan();
    listPersonil();
    getBobotKategoriTaskPM();
    getBobotKategoriTaskIndividu();
    getBobotTargetPoinPM();
    getBobotTargetPoinIndividu();
  }

  void refresh() {
    setState(() {
      task = getDataTask();
      getIdUser();
      getPekerjaan();
      listPersonil();
      getBobotKategoriTaskPM();
      getBobotKategoriTaskIndividu();
      getBobotTargetPoinPM();
      getBobotTargetPoinIndividu();
    });
  }

  getPekerjaan() async {
    var pekerjaan = await pekerjaanController.getPekerjaanById(idPekerjaan);
    setState(() {
      namaPekerjaan = pekerjaan[0].nama_pekerjaan.toString();
      idStatusPekerjaan = pekerjaan[0].id_status_pekerjaan.toString();
      idpm = pekerjaan[0].data_tambahan.project_manager[0].id_user;
    });
  }

  getBobotKategoriTaskPM() async {
    bool cekBobot = await bobotKategoriTaskController.cekBobotPM();
    setState(() {
      cekBobotKategoriTaskPM = cekBobot;
    });
    print('cekBobotKategoriTaskPM : $cekBobotKategoriTaskPM');
  }

  getBobotKategoriTaskIndividu() async {
    bool cekBobot = await bobotKategoriTaskController.cekBobotIndividu();
    setState(() {
      cekBobotKategoriTaskIndividu = cekBobot;
    });
    print('cekBobotKategoriTaskIndividu : $cekBobotKategoriTaskIndividu');
  }

  getBobotTargetPoinPM() async {
    bool cekBobot = await targetPoinHarianController.cekBobotPM();
    setState(() {
      cekTargetPoinPM = cekBobot;
    });
    print('cektargetpoinpm : $cekBobotKategoriTaskPM');
  }

  getBobotTargetPoinIndividu() async {
    bool cekBobot = await targetPoinHarianController.cekBobotIndividu();
    setState(() {
      cekTargetPoinIndividu = cekBobot;
    });
    print('cektargetpoinindividu : $cekBobotKategoriTaskIndividu');
  }

  List<String> dropdownItems = [
    'Semua',
    'On Progress',
    'Deadline Hari ini',
    'Overdue',
    'Sedang Verifikasi',
    'Ditolak',
    'Sudah Verifikasi'
  ];

  //SERVER
  // List<dynamic> statusItems = [];

  // Future<void> getStatusTask() async {
  //   // Replace with your method to fetch status tasks
  //   List statusTask = await statusTaskController.getAllStatusTask();
  //   setState(() {
  //     statusItems.clear();
  //     statusItems.add(StatusTaskModel(
  //       id_status_task: 'Status',
  //       nama_status_task: 'Status',
  //       deskripsi_status_task: 'Status',
  //       color: 'Status',
  //     ));
  //     statusItems.addAll(statusTask);
  //     if (statusItems.isNotEmpty) {
  //       statusTaskValue = statusItems[0].id_status_task;
  //     }
  //   });
  // }

  List<dynamic> userItems = [];

  Future<void> listPersonil() async {
    List listpersonil =
        await pekerjaanController.listPersonilPekerjaan(idPekerjaan);
    setState(() {
      userItems.clear();
      userItems.add({
        'id_user': 'Personil',
        'nama': 'Personil',
        'role_personil': 'Personil'
      });
      userItems.addAll(listpersonil);
      if (userItems.isNotEmpty) {
        userValue = userItems[0]['id_user'];
      }
    });
  }

  getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    setState(() {
      iduser = idUser.toString();
    });
    return idUser;
  }

  cekPM() async {
    var idUser = await getIdUser();
    var pekerjaan = await pekerjaanController.getPekerjaanById(idPekerjaan);
    if (idUser == pekerjaan[0].data_tambahan.project_manager[0].id_user) {
      setState(() {
        isPM = true;
      });
      return true;
    } else {
      setState(() {
        isPM = false;
      });
      return false;
    }
  }

  Future<List<TaskModel>> getDataTask() async {
    bool cekpm = await cekPM();
    if (cekpm) {
      List<TaskModel> taskPM =
          await taskController.getTasksByPekerjaanId(idPekerjaan);
      setState(() {
        isPM = true;
      });
      return taskPM;
    } else {
      List<TaskModel> tasknonPM =
          await taskController.getTasksByUserPekerjaan(idPekerjaan);
      setState(() {
        isPM = false;
      });
      return tasknonPM;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isSearchBarVisible
            ? TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (searchController.text.isNotEmpty) {
                          searchController.clear();
                        } else {
                          isSearchBarVisible = false;
                        }
                      });
                    },
                  ),
                ),
              )
            : Text(namaPekerjaan, style: const TextStyle(color: Colors.white)),
        actions: !isSearchBarVisible
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      isSearchBarVisible = !isSearchBarVisible;
                    });
                  },
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          buildFilterSection(),
          if (isPM == true)
            cekBobotKategoriTaskPM == false || cekTargetPoinPM == false
                ? buildWarningSection(
                    isPM, cekBobotKategoriTaskPM, cekTargetPoinPM)
                : Container()
          else
            cekBobotKategoriTaskIndividu == false ||
                    cekTargetPoinIndividu == false
                ? buildWarningSection(
                    isPM, cekBobotKategoriTaskIndividu, cekTargetPoinIndividu)
                : Container(),
          dropdownValue == 'Semua' ? buildKeteranganSection() : Container(),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 100),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SingleChildScrollView(
                    child: buildTask(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //jika pekerjaan bast atau cancel maka tidak bisa menambah task
      floatingActionButton: idStatusPekerjaan == '3' || idStatusPekerjaan == '5'
          ? null
          //jika seorang pm
          : isPM == true
              ? cekTargetPoinPM == false || cekBobotKategoriTaskPM == false
                  ? null
                  : FloatingActionButton(
                      backgroundColor: GlobalColors.mainColor,
                      onPressed: () {
                        Get.toNamed('/add_task/$idPekerjaan');
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    )
              //jika bukam pm
              : cekTargetPoinIndividu == false ||
                      cekBobotKategoriTaskIndividu == false
                  ? null
                  : FloatingActionButton(
                      backgroundColor: GlobalColors.mainColor,
                      onPressed: () {
                        Get.toNamed('/add_task/$idPekerjaan');
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
    );
  }

  Widget buildFilterSection() {
    return Container(
      color: GlobalColors.mainColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nama Personil
          isPM
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: DropdownButton<String>(
                        value: userValue,
                        dropdownColor: GlobalColors.mainColor,
                        icon:
                            const Icon(Icons.filter_list, color: Colors.white),
                        elevation: 16,
                        style: const TextStyle(color: Colors.blue),
                        onChanged: (String? newValue) {
                          setState(() {
                            userValue = newValue!;
                            task =
                                getDataTask(); // Refresh the task list based on the new filter
                          });
                        },
                        items: userItems.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value['id_user'],
                            child: Text(value['nama'],
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
              : Container(),
          // Status Task
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //hardcode
              DropdownButton<String>(
                value: dropdownValue,
                dropdownColor: GlobalColors.mainColor,
                icon: const Icon(Icons.filter_list, color: Colors.white),
                elevation: 16,
                style: const TextStyle(color: Colors.blue),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    task =
                        getDataTask(); // Refresh the task list based on the new filter
                  });
                },
                items:
                    dropdownItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),

              //SERVER
              // DropdownButton<String>(
              //   value: statusTaskValue,
              //   dropdownColor: GlobalColors.mainColor,
              //   icon: const Icon(Icons.filter_list, color: Colors.white),
              //   elevation: 16,
              //   style: const TextStyle(color: Colors.blue),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       statusTaskValue = newValue!;
              //       // Refresh the task list based on the new filter
              //       task = getDataTask();
              //     });
              //   },
              //   items: statusItems.map<DropdownMenuItem<String>>((value) {
              //     return DropdownMenuItem<String>(
              //       value: value.id_status_task,
              //       child: Text(value.nama_status_task,
              //           style: const TextStyle(color: Colors.white)),
              //     );
              //   }).toList(),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildKeteranganSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Keterangan: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Expanded(child: Text('On Progress')),
              const SizedBox(width: 10),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Expanded(child: Text('Deadline Hari ini')),
              const SizedBox(width: 10),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Expanded(child: Text('Overdue')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Expanded(child: Text('Sedang Verifikasi')),
              const SizedBox(width: 10),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Expanded(child: Text('Ditolak')),
              const SizedBox(width: 10),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Expanded(child: Text('Sudah Verifikasi')),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTask() {
    return FutureBuilder<List<TaskModel>>(
      future: task,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
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
          return const Center(
            child: Text(
              'Tidak ada data task',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          List<TaskModel> allTasks = snapshot.data!;
          DateTime currentDate = DateTime.now();
          DateTime today =
              DateTime(currentDate.year, currentDate.month, currentDate.day);

          final filterTask = allTasks
              .where((task) =>
                  task.deskripsi_task.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ) ||
                  task.data_tambahan.nama_user
                      .toString()
                      .contains(searchController.text) ||
                  task.tgl_planing.toString().contains(searchController.text))
              .where((task) {
            if (userValue == 'Personil') {
              return true;
            } else {
              return task.id_user == userValue;
            }
          }).where((task) {
            switch (dropdownValue) {
              case 'Semua':
                return true; // Tampilkan semua tugas
              case 'On Progress':
                return task.id_status_task == '1' &&
                    task.tgl_verifikasi_diterima == null &&
                    today.isBefore(task.tgl_planing);
              case 'Deadline Hari ini':
                return task.tgl_verifikasi_diterima == null &&
                    task.id_status_task == '1' &&
                    today.year == task.tgl_planing.year &&
                    today.month == task.tgl_planing.month &&
                    today.day == task.tgl_planing.day;
              case 'Overdue':
                return task.tgl_verifikasi_diterima == null &&
                    today.isAfter(task.tgl_planing) &&
                    task.id_status_task == '1';
              case 'Sedang Verifikasi':
                return task.id_status_task ==
                    '2'; //pending atau sedang verifikasi
              case 'Ditolak':
                return task.id_status_task == '4'; //ditolak atau cancel
              case 'Sudah Verifikasi':
                return task.id_status_task ==
                    '3'; //sudah verifikasi atau selesai
              default:
                return true;
            }
          }).toList();

          //SERVER
          // }).where((task) {
          //   if (statusTaskValue == 'Status') {
          //     return true;
          //   } else {
          //     return task.id_status_task == statusTaskValue;
          //   }
          // }).toList();
          return filterTask.isEmpty
              ? const Center(
                  child: Text(
                    'Data task kosong',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filterTask.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> taskData = filterTask[index].toJson();

                    //setting color card
                    DateTime currentDate = DateTime.now();
                    DateTime tglPlaning = taskData['tgl_planing'];
                    var statusTask = taskData['id_status_task'];
                    DateTime? tglVerifikasiDiterima;

                    if (taskData['tgl_verifikasi_diterima'] != null) {
                      // final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                      try {
                        tglVerifikasiDiterima =
                            taskData['tgl_verifikasi_diterima'];
                      } catch (e) {
                        print('Error parsing tgl_verifikasi_diterima: $e');
                        tglVerifikasiDiterima = null;
                      }
                    }

                    Color taskColor = GlobalColors.mainColor;
                    //belum verifikasi
                    if (tglVerifikasiDiterima == null &&
                        statusTask == '1' //on progress
                        &&
                        currentDate.isBefore(tglPlaning)) {
                      taskColor = GlobalColors.mainColor;
                    }
                    //deadline hari ini
                    else if (tglVerifikasiDiterima == null &&
                        statusTask == '1' //on progress
                        &&
                        currentDate.year == tglPlaning.year &&
                        currentDate.month == tglPlaning.month &&
                        currentDate.day == tglPlaning.day) {
                      taskColor = Colors.orange;
                    }
                    //overdue
                    else if (tglVerifikasiDiterima == null &&
                        statusTask == '1' //on progress
                        &&
                        currentDate.isAfter(tglPlaning)) {
                      taskColor = Colors.red;
                    }
                    //sedang verifikasi
                    else if (statusTask == '2') {
                      taskColor = Colors.pink;
                    }
                    //ditolak
                    else if (statusTask == '4') {
                      taskColor = Colors.purple;
                    }
                    //sudah verifikasi
                    else if (statusTask == '3') {
                      taskColor = Colors.green;
                    }
                    return Card(
                      color: taskColor,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/detail_task/${taskData['id_task']}',
                                  arguments: taskData);
                            },
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${taskData['persentase_selesai']}%',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                taskData['deskripsi_task'].length > 45
                                    ? taskData['deskripsi_task']
                                            .substring(0, 45) +
                                        '...'
                                    : taskData['deskripsi_task'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isPM == false
                                      ? Text(
                                          'Deadline : ${formatDate(taskData['tgl_planing'].toString())}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )
                                      : SizedBox(),
                                  isPM == true
                                      ? Text(
                                          taskData['data_tambahan']
                                                          ['nama_user'] !=
                                                      null &&
                                                  taskData['data_tambahan']
                                                              ['nama_user']
                                                          .length >
                                                      32
                                              ? 'Personil : ${taskData['data_tambahan']['nama_user'].substring(0, 32)}...'
                                              : 'Personil : ${taskData['data_tambahan']['nama_user']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                      '/detail_task/${taskData['id_task']}',
                                      arguments: taskData);
                                },
                                child: const Icon(
                                  Icons.event_note_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          //garis
                          taskData['tgl_verifikasi_diterima'] != null &&
                                      taskData['id_status_task'] == '3' ||
                                  taskData['id_status_task'] == '2' ||
                                  idStatusPekerjaan == '3' ||
                                  idStatusPekerjaan == '5'
                              ? const SizedBox()
                              : const Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                          taskData['tgl_verifikasi_diterima'] != null &&
                                      taskData['id_status_task'] == '3' ||
                                  taskData['id_status_task'] == '2' ||
                                  idStatusPekerjaan == '3' ||
                                  idStatusPekerjaan == '5'
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // Delete button
                                    Visibility(
                                      visible: idpm == iduser ||
                                          taskData['creator'] == iduser,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.white,
                                          iconSize:
                                              20, // Memperkecil ukuran ikon
                                          onPressed: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Konfirmasi Hapus Task"),
                                                  content: const Text(
                                                      "Apakah Anda yakin ingin menghapus task ini?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Batal"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(
                                                            context); // Close the dialog
                                                        bool taskDeleted =
                                                            await taskController
                                                                .deleteTask(taskData[
                                                                        'id_task']
                                                                    .toString());
                                                        if (taskDeleted) {
                                                          //menampilkan snackbar
                                                          Get.snackbar(
                                                              'Berhasil',
                                                              'Task berhasil dihapus',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white);
                                                          Get.offAndToNamed(
                                                              '/task/$idPekerjaan');
                                                          refresh();
                                                        } else {
                                                          Get.snackbar('Gagal',
                                                              'Task gagal dihapus',
                                                              backgroundColor:
                                                                  Colors.red,
                                                              colorText:
                                                                  Colors.white);
                                                        }
                                                      },
                                                      child:
                                                          const Text("Hapus"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // Edit button
                                    Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: Colors.white,
                                          iconSize:
                                              20, // Memperkecil ukuran ikon
                                          onPressed: () {
                                            Get.toNamed(
                                                '/edit_task/${taskData['id_task']}');
                                          },
                                        ),
                                      ),
                                    ),
                                    // Submit button
                                    Visibility(
                                      visible: taskData['id_user'] == iduser,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: IconButton(
                                          icon: const Icon(Icons.check),
                                          color: Colors.white,
                                          iconSize:
                                              20, // Memperkecil ukuran ikon
                                          onPressed: () {
                                            // Get.toNamed(
                                            //     '/submit_task/${taskData['id_task']}');
                                            Get.toNamed(
                                                '/submit_task/${taskData['id_task']}');
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    );
                  },
                );
        }
      },
    );
  }

  Widget buildWarningSection(bool pm, bool bobot, bool target) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          const Text(
            'Perhatian: ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 1,
          ),
          if (pm == false && bobot == false && target == false)
            const Text(
              'BOBOT KATEGORI TASK dan TARGET POIN HARIAN belum diatur, silahkan hubungi HOD',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          if (pm == false && bobot == false && target == true)
            const Text('BOBOT KATEGORI TASK belum diatur, silahkan hubungi HOD',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          if (pm == false && bobot == true && target == false)
            const Text('TARGET POIN HARIAN belum diatur, silahkan hubungi HOD',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          if (pm == true && bobot == false && target == false)
            const Text(
                'BOBOT KATEGORI TASK dan TARGET POIN HARIAN belum diatur, silahkan hubungi HOD',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          if (pm == true && bobot == false && target == true)
            const Text('BOBOT KATEGORI TASK belum diatur, silahkan hubungi HOD',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          if (pm == true && bobot == true && target == false)
            const Text('TARGET POIN HARIAN belum diatur, silahkan hubungi HOD',
                style: TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  //ubah format tanggal
  String formatDate(String date) {
    if (date == '-') {
      return '-';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'id').format(dateTime);
  }
}
