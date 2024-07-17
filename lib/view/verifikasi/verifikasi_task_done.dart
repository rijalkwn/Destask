import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/task_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VerifikasiTaskDone extends StatefulWidget {
  const VerifikasiTaskDone({super.key});

  @override
  State<VerifikasiTaskDone> createState() => _VerifikasiTaskDoneState();
}

class _VerifikasiTaskDoneState extends State<VerifikasiTaskDone> {
  final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
  TaskController taskController = TaskController();
  late Future<List<TaskModel>> task;

  Future<List<TaskModel>> getTask() async {
    print("id" + idPekerjaan);
    List<TaskModel> task = await taskController.getTaskVerifikator(idPekerjaan);
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
          'Task Sudah Verifikasi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildKeteranganSection(),
            const SizedBox(height: 10),
            Expanded(
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
                                Color taskColor = GlobalColors.mainColor;
                                if (taskData['id_status_task'] == '4') {
                                  taskColor = Colors.purple;
                                } else if (taskData['id_status_task'] == '3') {
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
                                          title: Text(
                                            taskData['deskripsi_task'].length >
                                                    70
                                                ? taskData['deskripsi_task']
                                                        .substring(0, 70) +
                                                    '...'
                                                : taskData['deskripsi_task'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Personil : ${taskData['data_tambahan']['nama_user']}',
                                                style: const TextStyle(
                                                    color: Colors.white),
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
          ],
        ),
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
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              const Expanded(child: Text('Diterima')),
            ],
          ),
        ],
      ),
    );
  }

  //ubah format tanggal
  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'id').format(dateTime);
  }
}
