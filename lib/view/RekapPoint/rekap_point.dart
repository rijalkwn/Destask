import 'package:destask/controller/bobot_kategori_task_controller.dart';
import 'package:destask/controller/kategori_task_controller.dart';
import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/task_model.dart';

import '../../model/pekerjaan_model.dart';
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
  late Map<String, Future<List<TaskModel>>> tasksMap = {};

  Future<List<PekerjaanModel>> getDataPekerjaan() async {
    var data = await pekerjaanController.getAllPekerjaanUser();
    return data;
  }

  Future<List<TaskModel>> getDataTask(String idPekerjaan) async {
    var data = await taskController.getTasksByUserPekerjaan(idPekerjaan);
    return data;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   pekerjaan = getDataPekerjaan().then((value) {
  //     for (var pekerjaanItem in value) {
  //       tasksMap[pekerjaanItem.id_pekerjaan.toString()] =
  //           getDataTask(pekerjaanItem.id_pekerjaan.toString());
  //     }
  //     return value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Center(
        //     child: Text(
        //       'Rekap Point',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        //   backgroundColor: GlobalColors.mainColor,
        //   iconTheme: IconThemeData(color: Colors.white),
        //   automaticallyImplyLeading: false,
        // ),
        // body: SingleChildScrollView(
        //   child: Container(
        //     child: FutureBuilder<List<PekerjaanModel>>(
        //       future: pekerjaan,
        //       builder: (context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return Center(child: CircularProgressIndicator());
        //         } else if (snapshot.hasError) {
        //           return Center(child: Text('Error: ${snapshot.error}'));
        //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //           return Center(child: Text('Tidak ada data pekerjaan'));
        //         } else {
        //           return ListView.builder(
        //             itemCount: snapshot.data!.length,
        //             itemBuilder: (context, index) {
        //               var pekerjaanItem = snapshot.data![index];
        //               return FutureBuilder<List<TaskModel>>(
        //                   future:
        //                       getDataTask(pekerjaanItem.id_pekerjaan.toString()),
        //                   builder: (context, snapshot) {
        //                     if (snapshot.connectionState ==
        //                         ConnectionState.waiting) {
        //                       return Center(child: CircularProgressIndicator());
        //                     } else if (snapshot.hasError) {
        //                       return Center(
        //                           child: Text('Error: ${snapshot.error}'));
        //                     } else if (!snapshot.hasData ||
        //                         snapshot.data!.isEmpty) {
        //                       return Center(child: Text('Tidak ada data task'));
        //                     } else {
        //                       return ExpansionTile(
        //                         title: Text(pekerjaanItem.nama_pekerjaan
        //                             .toString()
        //                             .toUpperCase()),
        //                         children: [
        //                           for (var taskItem in snapshot.data!)
        //                             Column(
        //                               children: [
        //                                 ListTile(
        //                                   title: Text(
        //                                     taskItem.deskripsi_task.toString(),
        //                                   ),
        //                                   subtitle: Text(
        //                                     taskItem.deskripsi_task
        //                                         .toString()
        //                                         .toUpperCase(),
        //                                   ),
        //                                   trailing: Container(
        //                                     decoration: BoxDecoration(
        //                                       color: GlobalColors.mainColor,
        //                                       shape: BoxShape.circle,
        //                                     ),
        //                                     child: Text(
        //                                       "12",
        //                                       style: TextStyle(
        //                                         color: Colors.white,
        //                                         fontWeight: FontWeight.bold,
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ),
        //                                 SizedBox(
        //                                     height:
        //                                         8), // Tambahkan SizedBox untuk memberikan sedikit ruang
        //                               ],
        //                             ),
        //                         ],
        //                       );
        //                     }
        //                   });
        //             },
        //           );
        //         }
        //       },
        //     ),
        //   ),
        // ),
        );
  }
}
