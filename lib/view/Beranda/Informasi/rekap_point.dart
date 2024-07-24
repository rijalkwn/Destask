import 'package:destask/controller/target_poin_harian_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RekapPoint extends StatefulWidget {
  const RekapPoint({Key? key}) : super(key: key);

  @override
  State<RekapPoint> createState() => _RekapPointState();
}

class _RekapPointState extends State<RekapPoint> {
  TaskController taskController = TaskController();
  TargetPoinHarianController targetPoinHarianController =
      TargetPoinHarianController();
  int totalPoint = 0;
  String totalPointTarget = '';

  getDataRekapPoint() async {
    var data = await taskController.getTaskRekapPointbyUser();
    return data;
  }

  getPoint() async {
    var data = await taskController.getTaskRekapPointbyUser();
    setState(() {
      totalPoint = 0;
      for (var task in data) {
        totalPoint += int.parse(task['bobot_point']);
      }
    });
  }

  getTargetpoint() async {
    var data = await targetPoinHarianController.getTarget();
    setState(() {
      totalPointTarget = data[0].jumlah_target_poin_sebulan.toString();
    });
  }

  //menampilkan nama bulan skrg
  String getMonthName() {
    var now = DateTime.now();
    var month = now.month;
    var monthName = '';
    switch (month) {
      case 1:
        monthName = 'Januari';
        break;
      case 2:
        monthName = 'Februari';
        break;
      case 3:
        monthName = 'Maret';
        break;
      case 4:
        monthName = 'April';
        break;
      case 5:
        monthName = 'Mei';
        break;
      case 6:
        monthName = 'Juni';
        break;
      case 7:
        monthName = 'Juli';
        break;
      case 8:
        monthName = 'Agustus';
        break;
      case 9:
        monthName = 'September';
        break;
      case 10:
        monthName = 'Oktober';
        break;
      case 11:
        monthName = 'November';
        break;
      case 12:
        monthName = 'Desember';
        break;
    }
    return monthName;
  }

  @override
  void initState() {
    super.initState();
    getTargetpoint();
    getPoint();
    getDataRekapPoint();
  }

  refresh() async {
    getTargetpoint();
    getPoint();
    getDataRekapPoint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rekap Point',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        // automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Total point target
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Target Point Bulan Ini:',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Text(
                              totalPointTarget,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Total point usergroup
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Bulan',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Text(
                              getMonthName(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Total point anda
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Point Anda Bulan Ini:',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                      Text(
                        totalPoint.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Daftar task
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                  future: getDataRekapPoint(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 200, horizontal: 20),
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
                              onTap: () {
                                refresh();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                    const Text(
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
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                snapshot.data[index]['deskripsi_task']
                                            .split(' ')
                                            .length >
                                        7
                                    ? '${snapshot.data[index]['deskripsi_task'].split(' ').sublist(0, 7).join(' ')}...'
                                    : snapshot.data[index]['deskripsi_task'],
                                style: const TextStyle(color: Colors.black),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                      'Tanggal Selesai: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(snapshot.data[index]['tgl_selesai']))}',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ],
                              ),
                              trailing: CircleAvatar(
                                backgroundColor: Colors.cyan,
                                child: Text(
                                  snapshot.data[index]['bobot_point'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
