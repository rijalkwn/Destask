import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/personil_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/pekerjaan_model.dart';
import 'package:destask/model/task_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Task extends StatefulWidget {
  const Task({Key? key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
  TextEditingController searchController = TextEditingController();
  PekerjaanController pekerjaanController = PekerjaanController();
  PersonilController personilController = PersonilController();
  TaskController taskController = TaskController();
  bool isSearchBarVisible = false;

  String namaPekerjaan = '';
  String id_pekerjaan = '';

  late DateTime _focusedDay;
  DateTime _selectedDay = DateTime.now();

  //pm
  bool isPM = false;
  late bool PM;

  late Future<List<TaskModel>> task;

  getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    return idUser;
  }

  //cek user pm apa bukan berdasarkan pekerjaan id
  cekPM() async {
    var idUser = await getIdUser();
    var dataPekerjaan = await pekerjaanController.getPekerjaanById(idPekerjaan);
    String idPersonil = dataPekerjaan[0].id_personil.toString();
    var dataPersonil = await personilController.getPersonilById(idPersonil);

    // Make sure 'id_user_pm' is of type String or handle type conversion accordingly
    String idUserPM = dataPersonil[0].id_user_pm.toString();

    if (idUser == idUserPM) {
      return true;
    }
    return false;
  }

  Future<List<TaskModel>> getDataTask() async {
    //cek PM
    PM = await cekPM();

    //untuk pm
    var task_PM =
        await taskController.getTasksByPekerjaanId(idPekerjaan, _selectedDay);
    //untuk non pm
    var task_nonPM =
        await taskController.getTasksByUserPekerjaan(idPekerjaan, _selectedDay);

    var pekerjaan = await pekerjaanController.getPekerjaanById(idPekerjaan);
    setState(() {
      namaPekerjaan = pekerjaan[0].nama_pekerjaan.toString();
      id_pekerjaan = pekerjaan[0].id_pekerjaan.toString();
    });
    return PM ? task_PM : task_nonPM;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    task = getDataTask();
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  Map<DateTime, List<dynamic>> _getEventsForDays() {
    Map<DateTime, List<dynamic>> events = {};

    // Ambil daftar tugas untuk tanggal yang sedang ditampilkan
    List<TaskModel> tasks = []; // Ambil tugas sesuai tanggal

    for (TaskModel task in tasks) {
      DateTime taskDate = DateTime.parse(task.tgl_planing!);
      // Tambahkan tugas ke daftar events
      events.putIfAbsent(taskDate, () => []);
    }

    return events;
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    task = getDataTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: isSearchBarVisible
            ? TextField(
                controller: searchController,
                style: TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.white),
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
            : Text(namaPekerjaan, style: TextStyle(color: Colors.white)),
        actions: !isSearchBarVisible
            ? [
                IconButton(
                  icon: Icon(Icons.search),
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
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TableCalendar(
              locale: 'id_ID',
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate: _selectedDayPredicate,
              onDaySelected: _onDaySelected,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
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
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: buildTask(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add_task/$id_pekerjaan',
              arguments: Get.parameters['idpekerjaan']);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget buildTask() {
    return FutureBuilder<List<TaskModel>>(
      future: task,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Task Kosong',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          List<TaskModel> allTasks = snapshot.data!;
          final filterTask = allTasks
              .where((task) =>
                  task.deskripsi_task!.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ) ||
                  task.tgl_planing!.contains(searchController.text))
              .toList();
          return allTasks.isEmpty
              ? Center(
                  child: Text(
                    'Task Kosong untuk hari ini',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filterTask.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> taskData = allTasks[index].toJson();
                    DateTime today = DateTime.now();
                    DateTime tglSelesai =
                        DateTime.parse(taskData['tgl_selesai']);
                    DateTime tglPlaning =
                        DateTime.parse(taskData['tgl_planing']);

                    // Set default color to blue
                    Color cardColor = Colors.blue;

                    // Check conditions and update color accordingly
                    if (today.isAfter(tglSelesai) &&
                            taskData['persentase_selesai'] != 100 ||
                        taskData['id_status_task'] != '2') {
                      cardColor = Colors.red;
                    } else if (today.isBefore(tglPlaning)) {
                      cardColor = Colors.orange;
                    } else if (today.isAfter(tglPlaning) &&
                        today.isBefore(tglSelesai)) {
                      cardColor = Colors.blue;
                    } else if (today.isAfter(tglSelesai) &&
                            taskData['persentase_selesai'] == 100 ||
                        taskData['id_status_task'] == '2') {
                      cardColor = Colors.green;
                    }

                    return Card(
                      color: cardColor,
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            taskData['persentase_selesai'].toString() + '%',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          taskData['deskripsi_task'].length > 20
                              ? taskData['deskripsi_task'].substring(0, 20) +
                                  '...'
                              : taskData['deskripsi_task'],
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Persentase : ${taskData['persentase_selesai']}%',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Deadline : ${taskData['tgl_selesai']}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap: () async {
                            TaskController taskController = TaskController();
                            bool cekDelete = await taskController
                                .deleteTask(taskData['id_task']);
                            if (cekDelete) {
                              Get.snackbar(
                                'Sukses',
                                'Task berhasil dihapus',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              await getDataTask();
                            } else {
                              Get.snackbar(
                                'Gagal',
                                'Task gagal dihapus',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Get.toNamed('/detail_task/${taskData['id_task']}');
                        },
                      ),
                    );
                  },
                );
        }
      },
    );
  }
}
