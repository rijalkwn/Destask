import 'package:destask/controller/bobot_kategori_task_controller.dart';
import 'package:destask/controller/kategori_task_controller.dart';
import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/model/bobot_kategori_task_model.dart';
import 'package:destask/model/kategori_task_model.dart';
import 'package:destask/model/task_model.dart';
import 'package:get/get.dart';

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

  //mengambil data pekerjaan
  Future<List<PekerjaanModel>> getDataPekerjaan() async {
    var data = await pekerjaanController.getAllPekerjaanUser();
    return data;
  }

  @override
  void initState() {
    super.initState();
    try {
      pekerjaan = getDataPekerjaan();
    } catch (e) {
      print(e);
    }
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
                List<dynamic> pekerjaan = snapshot.data as List<dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _ListOfJob(pekerjaan: pekerjaan),
                );
              } else {
                return Center(child: Text('No data available.'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class _ListOfJob extends StatelessWidget {
  const _ListOfJob({
    Key? key,
    required this.pekerjaan,
  }) : super(key: key);

  final List<dynamic> pekerjaan;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: pekerjaan.map((pekerjaanItem) {
          var namaPekerjaan = pekerjaanItem.nama_pekerjaan;
          return Card(
            color: GlobalColors.mainColor,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                    '/detail_rekap_point/${pekerjaanItem.id_pekerjaan}');
              },
              child: ListTile(
                title: Text(
                  namaPekerjaan.length > 20
                      ? '${namaPekerjaan.substring(0, 20)}...'
                      : namaPekerjaan,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "0",
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
