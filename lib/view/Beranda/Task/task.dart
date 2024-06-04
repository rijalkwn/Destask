import 'package:destask/controller/hari_libur_controller.dart';
import 'package:destask/controller/user_controller.dart';
import 'package:destask/model/hari_libur_model.dart';
import 'package:destask/model/user_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../../../controller/pekerjaan_controller.dart';
import '../../../controller/personil_controller.dart';
import '../../../controller/task_controller.dart';
import '../../../model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
  CalendarFormat _calendarFormat = CalendarFormat.week;
  TextEditingController searchController = TextEditingController();
  PekerjaanController pekerjaanController = PekerjaanController();
  PersonilController personilController = PersonilController();
  TaskController taskController = TaskController();
  UserController userController = UserController();
  HariLiburController hariLiburController = HariLiburController();
  bool isSearchBarVisible = false;
  bool libur = false;

  String namaPekerjaan = '';
  String dropdownValue = 'Semua';
  String selectedFilter = 'Semua';

  late DateTime _focusedDay;
  DateTime _selectedDay = DateTime.now();

  //pm
  bool isPM = false;

  late Future<List<TaskModel>> task;
  late Future<List> user;

  @override
  void initState() {
    super.initState();
    print(idPekerjaan);
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    getPekerjaan();
    //ceklibur
    cekHariLibur().then((value) {
      setState(() {
        libur = value;
      });
    });
    task = getDataTask();
  }

  void refresh() {
    setState(() {
      // Memperbarui data tugas dengan memanggil getDataTask()
      task = getDataTask();
      // Memperbarui status libur dengan memanggil cekHariLibur()
      cekHariLibur().then((value) {
        setState(() {
          libur = value;
        });
      });
    });
  }

  getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    return idUser;
  }

  //get data all user
  Future<List<UserModel>> getDataUser(String idUserTask) async {
    List<UserModel> data = await userController.getUserById(idUserTask);
    return data;
  }

  getPekerjaan() async {
    var pekerjaan = await pekerjaanController.getPekerjaanById(idPekerjaan);
    setState(() {
      namaPekerjaan = pekerjaan[0].nama_pekerjaan.toString();
    });
  }

  cekPM() async {
    var idUser = await getIdUser();
    var pekerjaan = await pekerjaanController.getPekerjaanById(idPekerjaan);
    if (idUser == pekerjaan[0].data_tambahan.pm[0].id_user) {
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
          await taskController.getTasksByPekerjaanId(idPekerjaan, _selectedDay);
      setState(() {
        isPM = true;
      });
      return taskPM;
    } else {
      List<TaskModel> tasknonPM = await taskController
          .getTasksByUserPekerjaanDate(idPekerjaan, _selectedDay);
      setState(() {
        isPM = false;
      });
      return tasknonPM;
    }
  }

  //hari libur
  Future<List<HariLiburModel>> getHariLibur() async {
    var data = await hariLiburController.getAllHariLibur();
    return data;
  }

  //cek jika hari libur maka add dan edit task tidak bisa diakses
  Future<bool> cekHariLibur() async {
    List<HariLiburModel> hariLibur = await getHariLibur();

    // Cek jika hari libur adalah Sabtu atau Minggu
    if (_selectedDay.weekday == 5 || _selectedDay.weekday == 7) {
      return true;
    }

    // Cek jika tanggal libur sesuai dengan tanggal yang dipilih
    for (var i = 0; i < hariLibur.length; i++) {
      if (isSameDay(_selectedDay, hariLibur[i].tanggal_libur)) {
        return true;
      }
    }

    return false;
  }

  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      // _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    // Pemanggilan fungsi cekHariLibur
    bool isLibur = await cekHariLibur();
    setState(() {
      libur = isLibur;
    });
    task = getDataTask();
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  Map<DateTime, List<TaskModel>> _getEventsForDays() {
    Map<DateTime, List<TaskModel>> events = {};

    // Ambil daftar tugas untuk tanggal yang sedang ditampilkan
    List<TaskModel> tasks = []; // Ambil tugas sesuai tanggal

    for (TaskModel task in tasks) {
      DateTime taskDate = task.tgl_planing;
      events.putIfAbsent(taskDate, () => []);
    }

    return events;
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            //TABEL CALENDAR
            TableCalendar(
              locale: 'id_ID',
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              selectedDayPredicate: _selectedDayPredicate,
              onDaySelected: _onDaySelected,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
              ),
              calendarStyle: const CalendarStyle(
                // outsideDaysVisible: false,
                todayDecoration:
                    BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                weekendTextStyle: TextStyle(color: Colors.red),
                selectedDecoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              ),
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
            const Divider(),
            //KETERANGAN
            Column(
              children: [
                const Text(
                  'Keterangan : ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: GlobalColors.mainColor,
                          shape: BoxShape.circle,
                        )),
                    const SizedBox(width: 5),
                    const Expanded(child: Text('On Progress')),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        )),
                    const SizedBox(width: 5),
                    const Expanded(child: Text('Deadline Hari ini')),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        )),
                    const SizedBox(width: 5),
                    const Expanded(child: Text('Overdue')),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        )),
                    const SizedBox(width: 5),
                    const Expanded(child: Text('Sedang Verifikasi')),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        )),
                    const SizedBox(width: 5),
                    const Expanded(child: Text('Ditolak')),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        )),
                    const SizedBox(width: 5),
                    const Expanded(child: Text('Sudah Verifikasi')),
                  ],
                ),
                //dropdown filter
                libur
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Filter : ' + selectedFilter,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.filter_list, color: Colors.black),
                            color: Colors.blue,
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Semua',
                                child: Text('Semua',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'On Progress',
                                child: Text('On Progress',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Deadline Hari ini',
                                child: Text('Deadline Hari ini',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Overdue',
                                child: Text('Overdue',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Sedang Verifikasi',
                                child: Text('Sedang Verifikasi',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Ditolak',
                                child: Text('Ditolak',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Sudah Verifikasi',
                                child: Text('Sudah Verifikasi',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                            onSelected: (String value) {
                              setState(() {
                                dropdownValue = value;
                                selectedFilter = value;
                                refresh();
                              });
                            },
                          ),
                        ],
                      ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            //LIST TASK
            Expanded(
              child: SingleChildScrollView(child: buildTask()),
            ),
          ],
        ),
      ),
      //TOMBOL ADD TASK
      floatingActionButton: libur
          ? null
          : FloatingActionButton(
              onPressed: () {
                Get.toNamed('/add_task/$idPekerjaan');
              },
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: GlobalColors.mainColor,
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
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 16),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return libur
              ? const Center(
                  child: Text(
                    'Hari ini adalah hari libur',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : const Center(
                  child: Text(
                    'Task Kosong untuk hari ini',
                    style: TextStyle(fontSize: 16),
                  ),
                );
        } else {
          List<TaskModel> allTasks = snapshot.data!;
          // final filterTask = allTasks
          //     .where((task) =>
          //         task.deskripsi_task.toLowerCase().contains(
          //               searchController.text.toLowerCase(),
          //             ) ||
          //         task.tgl_planing.toString().contains(searchController.text))
          //     .toList();
          DateTime currentDate = DateTime.now();

          final filterTask = allTasks
              .where((task) =>
                  task.deskripsi_task.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ) ||
                  task.tgl_planing.toString().contains(searchController.text))
              .where((task) {
            switch (dropdownValue) {
              case 'Semua':
                return true; // Tampilkan semua tugas
              case 'On Progress':
                return task.tgl_verifikasi_diterima == null &&
                    currentDate.isBefore(task.tgl_planing) &&
                    task.id_status_task == '1';
              case 'Deadline Hari ini':
                return task.tgl_verifikasi_diterima == null &&
                    currentDate.year == task.tgl_planing.year &&
                    currentDate.month == task.tgl_planing.month &&
                    currentDate.day == task.tgl_planing.day &&
                    task.id_status_task == '1';
              case 'Overdue':
                return task.tgl_verifikasi_diterima == null &&
                    currentDate.isAfter(task.tgl_planing) &&
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
          return libur
              ? const Center(
                  child: Text(
                    'Hari ini adalah hari libur',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : allTasks.isEmpty
                  ? const Center(
                      child: Text(
                        'Task Kosong untuk hari ini',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filterTask.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> taskData =
                            allTasks[index].toJson();

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
                                  Get.toNamed(
                                      '/detail_task/${taskData['id_task']}',
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
                                    taskData['deskripsi_task'].length > 20
                                        ? taskData['deskripsi_task']
                                                .substring(0, 20) +
                                            '...'
                                        : taskData['deskripsi_task'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Deadline : ${formatDate(taskData['tgl_planing'].toString())}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      isPM
                                          ? Text(
                                              'PIC : ${taskData['data_tambahan']['nama_user']}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  //jika libur = false maka edit task bisa diakses
                                  trailing: libur
                                      ? const SizedBox()
                                      : GestureDetector(
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
                              const Divider(
                                color: Colors.white,
                                thickness: 1,
                              ),
                              //tombol edit dan delete
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Delete button
                                  taskData['tgl_verifikasi_diterima'] != null &&
                                          taskData['id_status_task'] == '3'
                                      ? Container() // Use Container instead of SizedBox for consistency
                                      : Container(
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Konfirmasi Hapus Task"),
                                                    content: const Text(
                                                        "Apakah Anda yakin ingin menghapus task ini?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
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
                                                            Get.offAndToNamed(
                                                                '/task/$idPekerjaan');
                                                            QuickAlert.show(
                                                                context:
                                                                    context,
                                                                title:
                                                                    "Hapus Task Berhasil",
                                                                type: QuickAlertType
                                                                    .success);
                                                          } else {
                                                            QuickAlert.show(
                                                                context:
                                                                    context,
                                                                title:
                                                                    "Hapus Task Gagal",
                                                                type:
                                                                    QuickAlertType
                                                                        .error);
                                                          }
                                                        },
                                                        child: Text("Hapus"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                  // Edit button
                                  taskData['tgl_verifikasi_diterima'] == null &&
                                          taskData['id_status_task'] == '1'
                                      ? taskData['creator'] ==
                                              taskData['id_user']
                                          ? Container(
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
                                            )
                                          : Container()
                                      : Container(),
                                  // Submit button
                                  (taskData['tgl_verifikasi_diterima'] ==
                                                  null &&
                                              taskData['id_status_task'] ==
                                                  '1') ||
                                          taskData['id_status_task'] == '4'
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: IconButton(
                                            icon: const Icon(Icons.check),
                                            color: Colors.white,
                                            iconSize:
                                                20, // Memperkecil ukuran ikon
                                            onPressed: () {
                                              Get.toNamed(
                                                  '/submit_task/${taskData['id_task']}');
                                            },
                                          ),
                                        )
                                      : Container(),
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

  //ubah format tanggal
  String formatDate(String date) {
    if (date == '-') {
      return '-';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'id').format(dateTime);
  }
}
