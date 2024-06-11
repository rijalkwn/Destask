import 'package:destask/controller/rekap_point_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RekapPoint extends StatefulWidget {
  const RekapPoint({Key? key}) : super(key: key);

  @override
  State<RekapPoint> createState() => _RekapPointState();
}

class _RekapPointState extends State<RekapPoint> {
  RekapPointController rekapPointController = RekapPointController();
  DateTime? startDate;
  DateTime? endDate;
  int totalPoint = 0;

  getData() async {
    var data = await rekapPointController.getRekapPoint();
    if (startDate != null && endDate != null) {
      data = data.where((task) {
        DateTime taskDate = DateTime.parse(task['tgl_selesai']);
        return taskDate.isAfter(startDate!.subtract(const Duration(days: 1))) &&
            taskDate.isBefore(endDate!.add(const Duration(days: 1)));
      }).toList();
    } else if (startDate != null) {
      data = data.where((task) {
        DateTime taskDate = DateTime.parse(task['tgl_selesai']);
        return taskDate.isAfter(startDate!.subtract(const Duration(days: 1)));
      }).toList();
    } else if (endDate != null) {
      data = data.where((task) {
        DateTime taskDate = DateTime.parse(task['tgl_selesai']);
        return taskDate.isBefore(endDate!.add(const Duration(days: 1)));
      }).toList();
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Rekap Point',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            color: GlobalColors.mainColor,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                  future: getData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        totalPoint = 0;
                        for (var task in snapshot.data) {
                          totalPoint += int.parse(task['bobot_point']);
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Point:',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                              child: Center(
                                child: Text(
                                  totalPoint.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
                // Filter tanggal
                Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Dari:',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Sampai:',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  if (endDate != null) {
                                    if (picked.isAfter(endDate!)) {
                                      Get.snackbar('Error',
                                          'Tanggal awal tidak boleh lebih besar dari tanggal akhir!',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white);
                                    } else {
                                      setState(() {
                                        startDate = picked;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      startDate = picked;
                                    });
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  startDate == null
                                      ? Text('Pilih tanggal',
                                          style: const TextStyle(
                                              color: Colors.white))
                                      : Text(
                                          '${startDate!.day}/${startDate!.month}/${startDate!.year}',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                  SizedBox(width: 10),
                                  const Icon(Icons.calendar_today,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  if (startDate != null) {
                                    if (picked.isBefore(startDate!)) {
                                      Get.snackbar('Error',
                                          'Tanggal akhir tidak boleh lebih kecil dari tanggal awal!',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white);
                                    } else {
                                      setState(() {
                                        endDate = picked;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      endDate = picked;
                                    });
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  endDate == null
                                      ? Text('Pilih tanggal',
                                          style: const TextStyle(
                                              color: Colors.white))
                                      : Text(
                                          '${endDate!.day}/${endDate!.month}/${endDate!.year}',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                  SizedBox(width: 10),
                                  const Icon(Icons.calendar_today,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (startDate != null || endDate != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  startDate = null;
                                  endDate = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.red,
                                child: const Text(
                                  'Reset Filter',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Daftar task
          Expanded(
            child: FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Colors.lightGreen,
                          child: ListTile(
                            title: Text(
                              snapshot.data[index]['deskripsi_task']
                                          .split(' ')
                                          .length >
                                      20
                                  ? '${snapshot.data[index]['deskripsi_task'].split(' ').sublist(0, 20).join(' ')}...'
                                  : snapshot.data[index]['deskripsi_task'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                                'Tanggal Selesai: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(snapshot.data[index]['tgl_selesai']))}',
                                style: const TextStyle(color: Colors.white)),
                            trailing: Text(
                              'Point: ${snapshot.data[index]['bobot_point']}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
