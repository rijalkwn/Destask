import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/task_model.dart';
import 'package:destask/view/Beranda/Task/task.dart';
import '../../../model/pekerjaan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/global_colors.dart';

class TaskSelesai extends StatefulWidget {
  const TaskSelesai({super.key});

  @override
  State<TaskSelesai> createState() => _TaskSelesaiState();
}

class _TaskSelesaiState extends State<TaskSelesai> {
  TextEditingController searchController = TextEditingController();
  TaskController taskController = TaskController();
  bool isSearchBarVisible = false;
  String searchQuery = "";

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
            : const Text('Task Selesai', style: TextStyle(color: Colors.white)),
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
      body: FutureBuilder(
        future: taskController.getTaskBulanIni(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else if (snapshot.hasData) {
            List<TaskModel> task = snapshot.data!;
            final filteredList = task
                .where((task) =>
                    task.id_status_task == "3" &&
                    task.tgl_verifikasi_diterima != null &&
                    task.deskripsi_task!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();

            return TaskList(
              task: filteredList,
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<dynamic> task;

  const TaskList({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: task.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 3, left: 5, right: 5),
          child: Card(
            color: GlobalColors.mainColor,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${task[index].persentase_selesai}%',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              title: Text(
                task[index].deskripsi_task ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "PIC : ${task[index].data_tambahan.nama_user}",
                style: const TextStyle(color: Colors.white),
              ),
              trailing: GestureDetector(
                onTap: () {
                  Get.toNamed('/detail_task/${task[index].id_task}');
                },
                child: const Icon(
                  Icons.density_small,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
