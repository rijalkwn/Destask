import 'package:destask/controller/bobot_kategori_task_controller.dart';
import 'package:destask/controller/kategori_task_controller.dart';
import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/bobot_kategori_task_model.dart';
import 'package:destask/model/kategori_task_model.dart';
import 'package:destask/model/pekerjaan_model.dart';
import 'package:destask/model/task_model.dart';
import 'package:get/get.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';

class RekapPoint extends StatefulWidget {
  const RekapPoint({Key? key}) : super(key: key);

  @override
  State<RekapPoint> createState() => _RekapPointState();
}

class _RekapPointState extends State<RekapPoint> {
  PekerjaanController pekerjaanController = PekerjaanController();
  TaskController taskController = TaskController();
  KategoriTaskController kategoriTaskController = KategoriTaskController();
  BobotKategoriTaskController bobotKategoriTaskController =
      BobotKategoriTaskController();

  late Future<List<PekerjaanModel>> pekerjaan;
  List<KategoriTaskModel> listKategoriTask = [];
  List<BobotKategoriTaskModel> listBobotKategoriTask = [];
  List<int> totalPoinPerPekerjaan = [];
  int totalPoinPekerjaan = 0;

  // Mendapatkan data pekerjaan beserta total poin task untuk setiap pekerjaan
  Future<List<PekerjaanModel>> getDataPekerjaan() async {
    try {
      // Mendapatkan data pekerjaan
      var dataPekerjaan = await pekerjaanController.getAllPekerjaanUser();

      // Mendapatkan data kategori task dan bobot kategori task
      listKategoriTask = await kategoriTaskController.getAllKategoriTask();
      listBobotKategoriTask =
          await bobotKategoriTaskController.getAllBobotKategoriTask();

      // Mendapatkan total poin task untuk setiap pekerjaan
      List<int> totalPoinPerPekerjaan = [];
      for (var i = 0; i < dataPekerjaan.length; i++) {
        // Mendapatkan data task untuk pekerjaan saat ini
        var tasksForPekerjaan = await taskController
            .getTasksByUserPekerjaan(dataPekerjaan[i].id_pekerjaan.toString());

        // Menghitung total poin untuk setiap task pada pekerjaan saat ini
        int totalPoin = 0;
        for (var task in tasksForPekerjaan) {
          totalPoin += await calculateTotalPoinForTask(task);
        }

        // Menambahkan total poin pekerjaan saat ini ke dalam list
        totalPoinPerPekerjaan.add(totalPoin);
        //jumlah value dari totalPoinPerPekerjaan
        totalPoinPekerjaan = totalPoinPerPekerjaan.fold(
            0, (previousValue, element) => previousValue + element);
      }

      // Set state dengan total poin per pekerjaan
      setState(() {
        this.totalPoinPerPekerjaan = totalPoinPerPekerjaan;
      });

      // Mengembalikan data pekerjaan
      return dataPekerjaan;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Menghitung total poin untuk sebuah task
  Future<int> calculateTotalPoinForTask(TaskModel task) async {
    try {
      int totalPoin = 0;
      for (var kategoriTask in listKategoriTask) {
        if (task.id_kategori_task == kategoriTask.id_kategori_task) {
          for (var bobotKategori in listBobotKategoriTask) {
            if (kategoriTask.id_kategori_task ==
                bobotKategori.id_kategori_task) {
              totalPoin += int.parse(bobotKategori.bobot_poin.toString());
            }
          }
        }
      }
      return totalPoin;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    // Mendapatkan data pekerjaan saat inisialisasi widget
    pekerjaan = getDataPekerjaan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Rekap Point',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            //total point
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, right: 8.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //nama
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Point",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Point',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  CircleAvatar(
                    radius: 30,
                    backgroundColor: GlobalColors.mainColor,
                    child: Text(
                      totalPoinPekerjaan.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
            //judul list pekerjaan
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: FutureBuilder<List<PekerjaanModel>>(
                    future: pekerjaan,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 200),
                          child: Center(child: Text('No data available.')),
                        );
                      } else if (snapshot.hasData) {
                        List<PekerjaanModel> pekerjaan = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: _ListOfJob(
                              pekerjaan: pekerjaan,
                              totalPoinPerPekerjaan: totalPoinPerPekerjaan),
                        );
                      } else {
                        return Center(child: Text('No data available.'));
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListOfJob extends StatelessWidget {
  const _ListOfJob({
    Key? key,
    required this.pekerjaan,
    required this.totalPoinPerPekerjaan,
  }) : super(key: key);

  final List<PekerjaanModel> pekerjaan;
  final List<int> totalPoinPerPekerjaan;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: pekerjaan.map((pekerjaanItem) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                  '/detail_rekap_point/' +
                      pekerjaanItem.id_pekerjaan.toString(),
                  arguments: pekerjaanItem.id_pekerjaan);
            },
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    pekerjaanItem.nama_pekerjaan ?? '-',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: GlobalColors.mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                        "${totalPoinPerPekerjaan[pekerjaan.indexOf(pekerjaanItem)] == 0 ? '00' : totalPoinPerPekerjaan[pekerjaan.indexOf(pekerjaanItem)]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Divider(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
