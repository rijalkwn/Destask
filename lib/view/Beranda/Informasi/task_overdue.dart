import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskOverdue extends StatefulWidget {
  const TaskOverdue({super.key});

  @override
  State<TaskOverdue> createState() => _TaskOverdueState();
}

class _TaskOverdueState extends State<TaskOverdue> {
  TextEditingController searchController = TextEditingController();
  TaskController taskController = TaskController();
  bool isSearchBarVisible = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    getTask();
  }

  Future<void> refresh() async {
    setState(() {
      getTask();
    });
  }

  Future<List<TaskModel>> getTask() async {
    var data = await taskController.getTaskOverduebyUser();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isSearchBarVisible
            ? TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
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
                          searchQuery = "";
                        } else {
                          isSearchBarVisible = false;
                        }
                      });
                    },
                  ),
                ),
              )
            : const Text('Task Overdue', style: TextStyle(color: Colors.white)),
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
      body: FutureBuilder<List<TaskModel>>(
        future: getTask(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
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
                    onTap: refresh,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          Text(
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TaskList(tasks: snapshot.data!),
            );
          } else {
            return const Center(
              child: Text('Data tidak ditemukan'),
            );
          }
        },
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        var taskData = tasks[index];
        return Column(
          children: [
            Card(
              color: Colors.red,
              child: Column(
                children: [
                  GestureDetector(
                    child: ListTile(
                        onTap: () {
                          Get.toNamed('/detail_task/${taskData.id_task}');
                        },
                        title: Text(
                          taskData.deskripsi_task.length > 45
                              ? taskData.deskripsi_task.substring(0, 45) + '...'
                              : taskData.deskripsi_task,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        subtitle: Text(
                          'Deadline: ${formatDate(taskData.tgl_planing.toString())}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.check_box_outlined),
                          color: Colors.white,
                          onPressed: () {
                            Get.toNamed('/submit_task/${taskData.id_task}');
                          },
                        )),
                  ),
                ],
              ),
            ),
          ],
        );
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
