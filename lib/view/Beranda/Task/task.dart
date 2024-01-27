import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/personil_controller.dart';
import 'package:destask/controller/task_controller.dart';
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
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  bool isSearchBarVisible = false;
  TextEditingController searchController = TextEditingController();
  late List<dynamic> tasksList;
  String namaPekerjaan = '';
  String id_pekerjaan = '';
  bool isPM = false;
  late bool PM;
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    tasksList = [];
    fetchData();
  }

  Future getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    return idUser;
  }

  //cek user pm apa bukan berdasarkan pekerjaan id
  Future<bool> cekPM() async {
    var idUser = await getIdUser();
    PekerjaanController pekerjaanController = PekerjaanController();
    var dataPekerjaan = await pekerjaanController.getPekerjaanById(idPekerjaan);
    String idPersonil = dataPekerjaan['id_personil'];
    PersonilController personilController = PersonilController();
    var dataPersonil = await personilController.getPersonilById(idPersonil);

    // Make sure 'id_user_pm' is of type String or handle type conversion accordingly
    String idUserPM = dataPersonil[0]['id_user_pm'];

    if (idUser == idUserPM) {
      return true;
    }
    return false;
  }

  Future<void> fetchData() async {
    //cek PM
    PM = await cekPM();
    TaskController taskController = TaskController();
    List task_PM = await taskController.getTasksByPekerjaanId(idPekerjaan);
    List task_nonPM = await taskController.getTasksByUserPekerjaan(idPekerjaan);
    PekerjaanController pekerjaanController = PekerjaanController();
    Map<String, dynamic> pekerjaan =
        await pekerjaanController.getPekerjaanById(idPekerjaan);
    setState(() {
      namaPekerjaan = pekerjaan['nama_pekerjaan'] ?? '';
      id_pekerjaan = pekerjaan['id_pekerjaan'] ?? '';
      if (PM) {
        setState(() {
          tasksList = task_PM;
        });
      } else {
        setState(() {
          tasksList = task_nonPM;
        });
      }
    });
  }

  List<dynamic> _getTaskForDay(DateTime selectedDay, List<dynamic> tasks) {
    return tasks.where((task) {
      DateTime taskPlaning = DateTime.parse(task['tgl_planing']);
      DateTime taskSelesai = DateTime.parse(task['tgl_selesai']);
      return selectedDay.isAfter(taskPlaning.subtract(Duration(days: 1))) &&
          selectedDay.isBefore(taskSelesai.add(Duration(days: 1)));
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
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
              eventLoader: (day) => _getTaskForDay(day, tasksList),
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),
              calendarStyle: const CalendarStyle(
                // outsideDaysVisible: false,
                todayDecoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                weekendTextStyle: TextStyle(color: Colors.red),
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
    List<dynamic> filteredTasks = _getTaskForDay(_selectedDay!, tasksList);
    return filteredTasks.isEmpty
        ? Center(
            child: Text(
              'Task Kosong',
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> taskData = filteredTasks[index];
              DateTime today = DateTime.now();
              DateTime targetDate = DateTime.parse(taskData['tgl_selesai']);
              DateTime planningDate = DateTime.parse(taskData['tgl_planing']);

              // Set default color to blue
              Color cardColor = Colors.blue;

              // Check conditions and update color accordingly
              if (today.isAfter(targetDate) &&
                      taskData['persentase_selesai'] != 100 ||
                  taskData['id_status_task'] != '2') {
                cardColor = Colors.red;
              } else if (today.isBefore(planningDate)) {
                cardColor = Colors.orange;
              } else if (today.isAfter(planningDate) &&
                  today.isBefore(targetDate)) {
                cardColor = Colors.blue;
              } else if (today.isAfter(targetDate) &&
                      taskData['persentase_selesai'] == 100 ||
                  taskData['id_status_task'] == '2') {
                cardColor = Colors.green;
              }
              return Card(
                color: cardColor,
                child: ListTile(
                  title: Text(
                    taskData['deskripsi_task'],
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  subtitle: Text(
                    'Persentase : ${taskData['persentase_selesai']}%',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      TaskController taskController = TaskController();
                      bool cekDelete =
                          await taskController.deleteTask(taskData['id_task']);
                      if (cekDelete) {
                        Get.snackbar(
                          'Sukses',
                          'Task berhasil dihapus',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        fetchData();
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
                    Get.toNamed('/detail_task', arguments: taskData);
                  },
                ),
              );
            },
          );
  }
}
