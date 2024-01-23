import 'dart:async';

import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/Pekerjaan/pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TaskController taskController = Get.put(TaskController());
  TextEditingController searchController = TextEditingController();
  String namaPekerjaan = '';
  bool isSearchBarVisible = false;
  String searchQuery = ''; // Added for search functionality

  Future<Map<String, dynamic>> fetchData() async {
    final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
    PekerjaanController pekerjaanController = PekerjaanController();
    Map<String, dynamic> pekerjaan =
        await pekerjaanController.getPekejaanById(idPekerjaan);
    return pekerjaan;
  }

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

  @override
  Widget build(BuildContext context) {
    final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
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
            : Hero(
                tag: namaPekerjaan,
                child: Text(
                  namaPekerjaan != ''
                      ? (namaPekerjaan.length > 20
                          ? '${namaPekerjaan.substring(0, 20)}...'
                          : namaPekerjaan)
                      : '',
                  style: TextStyle(color: Colors.white),
                ),
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
          labelPadding: EdgeInsets.symmetric(horizontal: 10),
          tabs: [
            Tab(text: 'Planning'),
            Tab(text: 'Hari Ini'),
            Tab(text: 'OverDue'),
          ],
          labelStyle: TextStyle(fontSize: 17),
          unselectedLabelStyle: TextStyle(fontSize: 16),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.blue[100],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //planning
          FutureBuilder<List<dynamic>>(
            future: taskController.getTasksByPekerjaanId(idPekerjaan),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> planningTask = snapshot.data!.where((task) {
                  DateTime tanggalMulai = DateTime.parse(task['tanggal_mulai']);
                  return tanggalMulai.isAfter(DateTime.now());
                }).toList();
                return TaskList(
                    tasks: planningTask,
                    taskController: taskController,
                    searchQuery: searchQuery);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          //hari ini
          FutureBuilder<List<dynamic>>(
            future: taskController.getTasksByPekerjaanId(idPekerjaan),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> todayTask = snapshot.data!.where((task) {
                  DateTime tanggalMulai = DateTime.parse(task['tanggal_mulai']);
                  DateTime tanggalSelesai =
                      DateTime.parse(task['tanggal_selesai']);
                  return tanggalMulai.isBefore(DateTime.now()) &&
                      tanggalSelesai.isAfter(DateTime.now());
                }).toList();
                return TaskList(
                    tasks: todayTask,
                    taskController: taskController,
                    searchQuery: searchQuery);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          //overdue
          FutureBuilder<List<dynamic>>(
            future: taskController.getTasksByPekerjaanId(idPekerjaan),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> overdueTask = snapshot.data!.where((task) {
                  DateTime tanggalSelesai =
                      DateTime.parse(task['tanggal_selesai']);
                  return tanggalSelesai.isBefore(DateTime.now());
                }).toList();
                return TaskList(
                    tasks: overdueTask,
                    taskController: taskController,
                    searchQuery: searchQuery);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add_task/$idPekerjaan');
        },
        backgroundColor: GlobalColors.mainColor,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<dynamic> tasks;
  final TaskController taskController;
  final String searchQuery;

  TaskList(
      {required this.tasks,
      required this.taskController,
      required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
    final filteredList = tasks.where((task) =>
        task['nama_task'].toLowerCase().contains(searchQuery.toLowerCase()) ||
        task['detail_task'].toLowerCase().contains(searchQuery.toLowerCase()));

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var task = filteredList.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Card(
            color: GlobalColors.mainColor,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              title: Text(
                task['nama_task'],
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                task['detail_task'],
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed('/edit_task/' + task['idtask']);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      bool deletedSuccessfully =
                          await taskController.deleteTask(task['idtask']);
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
  }
}
