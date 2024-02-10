import 'package:destask/controller/bobot_kategori_task_controller.dart';
import 'package:destask/controller/kategori_task_controller.dart';
import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/bobot_kategori_task_model.dart';
import 'package:destask/model/kategori_task_model.dart';
import 'package:destask/model/task_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailRekapPoint extends StatefulWidget {
  const DetailRekapPoint({super.key});

  @override
  State<DetailRekapPoint> createState() => _DetailRekapPointState();
}

class _DetailRekapPointState extends State<DetailRekapPoint> {
  final String idpekerjaan = Get.parameters['idpekerjaan'] ?? '';
  TaskController taskController = TaskController();
  KategoriTaskController kategoriTaskController = KategoriTaskController();
  PekerjaanController pekerjaanController = PekerjaanController();
  BobotKategoriTaskController bobotKategoriTaskController =
      BobotKategoriTaskController();
  late Future<List<TaskModel>> task;
  List<KategoriTaskModel> listKategoriTask = [];
  List<BobotKategoriTaskModel> listBobotKategoriTask = [];
  List<String> namaKategoriTask = [];
  List<int> pointKategoriTask = [];
  String namaPekerjaan = '';

  //getdata task
  Future<List<TaskModel>> getDataTask() async {
    try {
      var data = await taskController.getTasksByUserPekerjaan(idpekerjaan);
      return data;
    } catch (e) {
      print("Error in getDataTask: $e");
      return [];
    }
  }

  Future<List<KategoriTaskModel>> getDataKategoriTask() async {
    try {
      var data = await kategoriTaskController.getAllKategoriTask();
      return data;
    } catch (e) {
      print("Error in getDataKategoriTask: $e");
      return [];
    }
  }

  Future<List<BobotKategoriTaskModel>> getDataBobotKategoriTask() async {
    try {
      var data = await bobotKategoriTaskController.getAllBobotKategoriTask();
      return data;
    } catch (e) {
      print("Error in getDataBobotKategoriTask: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      task = getDataTask().then((value) async {
        if (value.isEmpty) {
          return value;
        }
        // Mengambil data kategori task
        listKategoriTask = await getDataKategoriTask();
        // Mengambil data bobot kategori task
        listBobotKategoriTask = await getDataBobotKategoriTask();

        // Initialize lists with length equal to the number of tasks
        List<String> namaKategoriTask = List.filled(value.length, '');
        List<int> pointKategoriTask = List.filled(value.length, 0);

        for (var i = 0; i < value.length; i++) {
          for (var j = 0; j < listKategoriTask.length; j++) {
            if (value[i].id_kategori_task ==
                listKategoriTask[j].id_kategori_task) {
              // Assign namaKategoriTask at the corresponding index
              namaKategoriTask[i] =
                  listKategoriTask[j].nama_kategori_task.toString();
            }
          }
          // Assign pointKategoriTask at the corresponding index
          var currentTaskId = value[i].id_kategori_task;
          var bobotIndex = listBobotKategoriTask
              .indexWhere((bobot) => bobot.id_kategori_task == currentTaskId);
          if (bobotIndex != -1) {
            pointKategoriTask[i] = int.parse(
                listBobotKategoriTask[bobotIndex].bobot_poin.toString());
          }
        }

        setState(() {
          namaPekerjaan = value[0].data_tambahan.nama_pekerjaan;
          // Update the state with the initialized lists
          this.namaKategoriTask = namaKategoriTask;
          this.pointKategoriTask = pointKategoriTask;
        });

        return value;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Rekap Point',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //nama
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaPekerjaan,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Total Point',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  CircleAvatar(
                    radius: 30,
                    backgroundColor: GlobalColors.mainColor,
                    child: Text(
                      pointKategoriTask
                          .fold<int>(0, (p, c) => p + c)
                          .toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            //task terselesaikan
            const Text(
              'Task Terselesaikan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
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
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No tasks available.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final String deskripsiTask =
                            snapshot.data![index].deskripsi_task ?? '';
                        final String kategoriTask =
                            index < namaKategoriTask.length
                                ? namaKategoriTask[index]
                                : '';
                        final int pointTask = index < pointKategoriTask.length
                            ? pointKategoriTask[index]
                            : 0;

                        return Card(
                          child: ListTile(
                            title: Text(deskripsiTask),
                            subtitle: Text('Kategori Task: $kategoriTask'),
                            trailing: Text(
                              'Point: $pointTask',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
