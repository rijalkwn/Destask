import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/task_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:table_calendar/table_calendar.dart';

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TaskController _taskController = TaskController();
  TextEditingController searchController = TextEditingController();
  bool isSearchBarVisible = false;
  String searchQuery = '';
  String namaPekerjaan = '';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchData().then((data) {
      setState(() {
        namaPekerjaan = data['nama_pekerjaan'];
      });
    });
  }

  Future<Map<String, dynamic>> fetchData() async {
    final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
    PekerjaanController pekerjaanController = PekerjaanController();
    Map<String, dynamic> pekerjaan =
        await pekerjaanController.getPekejaanById(idPekerjaan);
    return pekerjaan;
  }

  List<dynamic> _getTaskForDay(DateTime selectedDay) {
    return [];
  }

  FutureBuilder<List<dynamic>> _buildTaskForDay(DateTime selectedDay) {
    final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
    return FutureBuilder<List<dynamic>>(
      future: _taskController.getTasksByPekerjaanId(idPekerjaan),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return CircularProgressIndicator(
            color: Colors.white,
          );
        } else if (snapshot.hasError) {
          // Error state
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData || snapshot.data!.isEmpty) {
          // Success state
          List<dynamic> tasks = snapshot.data ?? [];
          List<dynamic> tasksForDay = tasks.where((task) {
            DateTime startDate = DateTime.parse(task['tanggal_mulai']);
            DateTime endDate = DateTime.parse(task['tanggal_selesai']);
            return selectedDay.isAtSameMomentAs(startDate) ||
                selectedDay.isAtSameMomentAs(endDate) ||
                (selectedDay.isAfter(startDate) &&
                    selectedDay.isBefore(endDate));
          }).toList();

          return ListView.builder(
            itemCount: tasksForDay.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                child: Card(
                  color: GlobalColors.mainColor,
                  child: ListTile(
                    title: Text(tasksForDay[index]['nama_task'],
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(tasksForDay[index]['detail_task'],
                        style: TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.toNamed(
                                '/edit_task/' + tasksForDay[index]['idtask']);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool deletedSuccessfully = await _taskController
                                .deleteTask(tasksForDay[index]['idtask']);
                            if (deletedSuccessfully) {
                              // Refresh halaman
                              Get.offAndToNamed('/task/$idPekerjaan');
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Task berhasil dihapus!',
                              );
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Task gagal dihapus, silahkan coba lagi!',
                              );
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          // no data
          return Center(
            child: Text(
              'Tidak ada task untuk hari ini!',
              style: TextStyle(color: Colors.black),
            ),
          );
        }
      },
    );
  }

  //today
  FutureBuilder<List<dynamic>> _buildTaskForPlanningDay(DateTime selectedDay) {
    final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
    return FutureBuilder<List<dynamic>>(
      future: _taskController.getTasksByPekerjaanId(idPekerjaan),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return CircularProgressIndicator(
            color: Colors.white,
          );
        } else if (snapshot.hasError) {
          // Error state
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData || snapshot.data!.isEmpty) {
          // Success state
          List<dynamic> tasks = snapshot.data ?? [];
          List<dynamic> tasksForDay = tasks.where((task) {
            DateTime startDate = DateTime.parse(task['tanggal_mulai']);
            DateTime endDate = DateTime.parse(task['tanggal_selesai']);
            return selectedDay.isAtSameMomentAs(startDate) ||
                selectedDay.isAtSameMomentAs(endDate) ||
                (selectedDay.isAfter(startDate) &&
                    selectedDay.isBefore(endDate));
          }).toList();

          return ListView.builder(
            itemCount: tasksForDay.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                child: Card(
                  color: GlobalColors.mainColor,
                  child: ListTile(
                    title: Text(tasksForDay[index]['nama_task'],
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(tasksForDay[index]['detail_task'],
                        style: TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.toNamed(
                                '/edit_task/' + tasksForDay[index]['idtask']);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool deletedSuccessfully = await _taskController
                                .deleteTask(tasksForDay[index]['idtask']);
                            if (deletedSuccessfully) {
                              // Refresh halaman
                              Get.offAndToNamed('/task/$idPekerjaan');
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Task berhasil dihapus!',
                              );
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Task gagal dihapus, silahkan coba lagi!',
                              );
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          // no data
          return Center(
            child: Text(
              'Tidak ada task untuk hari ini!',
              style: TextStyle(color: Colors.black),
            ),
          );
        }
      },
    );
  }

  //overdue
  FutureBuilder<List<dynamic>> _buildTaskForOverdueDay(DateTime selectedDay) {
    final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
    return FutureBuilder<List<dynamic>>(
      future: _taskController.getTasksByPekerjaanId(idPekerjaan),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return CircularProgressIndicator(
            color: Colors.white,
          );
        } else if (snapshot.hasError) {
          // Error state
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData || snapshot.data!.isEmpty) {
          // Success state
          List<dynamic> tasks = snapshot.data ?? [];
          List<dynamic> tasksForDay = tasks.where((task) {
            DateTime startDate = DateTime.parse(task['tanggal_mulai']);
            DateTime endDate = DateTime.parse(task['tanggal_selesai']);
            return selectedDay.isAtSameMomentAs(startDate) ||
                selectedDay.isAtSameMomentAs(endDate) ||
                (selectedDay.isAfter(startDate) &&
                    selectedDay.isBefore(endDate));
          }).toList();

          return ListView.builder(
            itemCount: tasksForDay.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                child: Card(
                  color: GlobalColors.mainColor,
                  child: ListTile(
                    title: Text(tasksForDay[index]['nama_task'],
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(tasksForDay[index]['detail_task'],
                        style: TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.toNamed(
                                '/edit_task/' + tasksForDay[index]['idtask']);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool deletedSuccessfully = await _taskController
                                .deleteTask(tasksForDay[index]['idtask']);
                            if (deletedSuccessfully) {
                              // Refresh halaman
                              Get.offAndToNamed('/task/$idPekerjaan');
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Task berhasil dihapus!',
                              );
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Task gagal dihapus, silahkan coba lagi!',
                              );
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          // no data
          return Center(
            child: Text(
              'Tidak ada task untuk hari ini!',
              style: TextStyle(color: Colors.black),
            ),
          );
        }
      },
    );
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

  //firstday
  // final DateTime _firstDayPlanning = DateTime.now().add(Duration(days: 1));
  // final DateTime _firstDayToday = DateTime.now().subtract(Duration(days: 3));
  // final DateTime _firstDayOverdue = DateTime.utc(2000, 01, 01);

  //lastday
  // final DateTime _lastDayPlanning = DateTime.utc(2030, 12, 31);
  // final DateTime _lastDayToday = DateTime.now().add(Duration(days: 3));
  // final DateTime _lastDayOverdue = DateTime.now().subtract(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: isSearchBarVisible
            ? TextField(
                controller: searchController,
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
                style: TextStyle(color: Colors.white),
                autofocus: true,
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
            : Text(
                namaPekerjaan != ''
                    ? (namaPekerjaan.length > 20
                        ? '${namaPekerjaan.substring(0, 20)}...'
                        : namaPekerjaan)
                    : '',
                style: TextStyle(color: Colors.white),
              ),
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(text: 'Planning'),
            Tab(text: 'Today'),
            Tab(text: 'Overdue'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //Planning
          Column(
            children: [
              TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime.now().subtract(Duration(days: 1)),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                startingDayOfWeek: StartingDayOfWeek.monday,
                eventLoader: _getTaskForDay,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                ),
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration:
                      BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              Expanded(
                child: _buildTaskForPlanningDay(_selectedDay ?? DateTime.now()),
              ),
            ],
          ),
          //Today
          Column(
            children: [
              TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime.now().subtract(Duration(days: 3)),
                lastDay: DateTime.now().add(Duration(days: 3)),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                startingDayOfWeek: StartingDayOfWeek.monday,
                eventLoader: _getTaskForDay,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                ),
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration:
                      BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              Expanded(child: _buildTaskForDay(_selectedDay ?? DateTime.now())),
            ],
          ),
          //Overdue
          Column(
            children: [
              TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime.utc(2000, 01, 01),
                lastDay: DateTime.now().add(Duration(days: 1)),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                startingDayOfWeek: StartingDayOfWeek.monday,
                eventLoader: _getTaskForDay,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                ),
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration:
                      BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              Expanded(
                  child:
                      _buildTaskForOverdueDay(_selectedDay ?? DateTime.now())),
            ],
          ),
        ],
      ),
    );
  }
}
