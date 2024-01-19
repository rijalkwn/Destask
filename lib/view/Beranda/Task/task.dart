import 'package:destask/controller/task_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TaskController _taskController = Get.put(TaskController());
  bool isSearchBarVisible = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
    print('$idPekerjaan');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: isSearchBarVisible
            ? TextField(
                // controller: searchController,
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
                        // searchController.clear();
                      });
                    },
                  ),
                ),
              )
            : Text('Pekerjaan', style: TextStyle(color: Colors.white)),
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
            future: _taskController.getTasksByPekerjaanId(idPekerjaan),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> planningTask = snapshot.data!.where((task) {
                  DateTime tanggalMulai = DateTime.parse(task['tanggal_mulai']);
                  return tanggalMulai.isAfter(DateTime.now());
                }).toList();
                return ListView.builder(
                  itemCount: planningTask.length,
                  itemBuilder: (context, index) {
                    var task = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Card(
                        color: GlobalColors.mainColor,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                  Get.toNamed('/edit_task/$idPekerjaan');
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.toNamed('/del_task/$idPekerjaan');
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          //hari ini
          FutureBuilder<List<dynamic>>(
            future: _taskController.getTasksByPekerjaanId(idPekerjaan),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> planningTask = snapshot.data!.where((task) {
                  DateTime tanggalMulai = DateTime.parse(task['tanggal_mulai']);
                  DateTime tanggalSelesai =
                      DateTime.parse(task['tanggal_selesai']);
                  return tanggalMulai.isBefore(DateTime.now());
                }).toList();
                return ListView.builder(
                  itemCount: planningTask.length,
                  itemBuilder: (context, index) {
                    var task = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Card(
                        color: GlobalColors.mainColor,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          title: Text(
                            task['nama_task'],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            task['detail_task'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          //overdue
          FutureBuilder<List<dynamic>>(
            future: _taskController.getTasksByPekerjaanId(idPekerjaan),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> planningTask = snapshot.data!.where((task) {
                  DateTime tanggalSelesai =
                      DateTime.parse(task['tanggal_selesai']);
                  return tanggalSelesai.isAfter(DateTime.now());
                }).toList();
                return ListView.builder(
                  itemCount: planningTask.length,
                  itemBuilder: (context, index) {
                    var task = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Card(
                        color: GlobalColors.mainColor,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          title: Text(
                            task['nama_task'],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            task['detail_task'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
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
        child: Icon(Icons.add),
      ),
    );
  }
}
