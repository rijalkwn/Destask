import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/task_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VerifikasiTask extends StatefulWidget {
  const VerifikasiTask({super.key});

  @override
  State<VerifikasiTask> createState() => _VerifikasiTaskState();
}

class _VerifikasiTaskState extends State<VerifikasiTask> {
  final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
  TaskController taskController = TaskController();
  late Future<List<TaskModel>> task;

  Future<List<TaskModel>> getTask() async {
    print("id" + idPekerjaan);
    List<TaskModel> task = await taskController.getTaskVerifikasi(idPekerjaan);
    return task;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    task = getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi Task',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: FutureBuilder<List<TaskModel>>(
            future: task,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<TaskModel> allTasks = snapshot.data!;
                return allTasks.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada data verifikasi task',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allTasks.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> taskData =
                              allTasks[index].toJson();
                          return Card(
                            color: GlobalColors.mainColor,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                        '/detail_verifikasi/${taskData['id_task']}',
                                        arguments: taskData);
                                  },
                                  child: ListTile(
                                    title: Text(
                                      taskData['deskripsi_task'].length > 70
                                          ? taskData['deskripsi_task']
                                                  .substring(0, 70) +
                                              '...'
                                          : taskData['deskripsi_task'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
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
                                        ),
                                      ],
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
              } else {
                return const Center(
                  child: Text('Tidak ada data'),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  //ubah format tanggal
  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'id').format(dateTime);
  }
}
