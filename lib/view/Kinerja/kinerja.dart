import 'package:destask/controller/kinerja_controller.dart';
import 'package:destask/model/kinerja_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Kinerja extends StatefulWidget {
  const Kinerja({Key? key}) : super(key: key);

  @override
  State<Kinerja> createState() => _KinerjaState();
}

class _KinerjaState extends State<Kinerja> {
  TextEditingController searchController = TextEditingController();
  KinerjaController kinerjaController = KinerjaController();
  late Future<List<KinerjaModel>> kinerja;
  String dropdownValue = 'Semua';

  Future<List<KinerjaModel>> getDataKinerja() async {
    var data = await kinerjaController.getKinerjaUser();
    return data;
  }

  @override
  void initState() {
    super.initState();
    kinerja = getDataKinerja();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Kinerja',
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
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tahun: ',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 10),
                //filter tahun
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  elevation: 16,
                  dropdownColor: GlobalColors.mainColor,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      kinerja =
                          getDataKinerja(); // Refresh the task list based on the new filter
                    });
                  },
                  items: <String>[
                    'Semua',
                    '2022',
                    '2023',
                    '2024',
                    '2025',
                    '2026',
                    '2027',
                    '2028',
                    '2029',
                    '2030'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Daftar task
          Expanded(
            child: FutureBuilder<List<KinerjaModel>>(
              future: kinerja,
              builder: (BuildContext context,
                  AsyncSnapshot<List<KinerjaModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // return ListView.builder(
                  //   itemCount: snapshot.data!.length,
                  //   itemBuilder: (context, index) {
                  //     KinerjaModel kinerjaData = snapshot.data![index];
                  //     return Card(
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           Get.toNamed('/detail_kinerja',
                  //               arguments: kinerjaData.toJson());
                  //         },
                  //         child: ListTile(
                  //           title: Text(kinerjaData.bulan),
                  //           subtitle: Text(kinerjaData.tahun),
                  //           trailing: Text(
                  //             kinerjaData.score_kpi.toString(),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                  List<KinerjaModel> allKinerja = snapshot.data!;
                  final filterKinerja = allKinerja
                      .where((kinerja) => kinerja.bulan.toLowerCase().contains(
                            searchController.text.toLowerCase(),
                          ))
                      .where((kinerja) {
                    switch (dropdownValue) {
                      case 'Semua':
                        return true; // Tampilkan semua tugas
                      case '2022':
                        return kinerja.tahun == '2022';
                      case '2023':
                        return kinerja.tahun == '2023';
                      case '2024':
                        return kinerja.tahun == '2024';
                      case '2025':
                        return kinerja.tahun == '2025';
                      case '2026':
                        return kinerja.tahun == '2026';
                      case '2027':
                        return kinerja.tahun == '2027';
                      case '2028':
                        return kinerja.tahun == '2028';
                      case '2029':
                        return kinerja.tahun == '2029';
                      case '2030':
                        return kinerja.tahun == '2030';
                      default:
                        return true;
                    }
                  }).toList();
                  // Check if filtered list is empty
                  if (filterKinerja.isEmpty) {
                    return const Center(
                      child: Text(
                        'Data Tidak Ditemukan',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return allKinerja.isEmpty
                      ? const Center(
                          child: Text(
                            'Data Belum Tersedia',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filterKinerja.length,
                          itemBuilder: (context, index) {
                            KinerjaModel kinerjaData = filterKinerja[index];
                            // Parse the month number and convert it to a month name
                            int monthNumber = int.parse(kinerjaData.bulan);
                            String monthName = DateFormat.MMMM()
                                .format(DateTime(0, monthNumber));

                            return Card(
                                color: GlobalColors.mainColor,
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                        'ini id kinerja ${kinerjaData.id_kinerja}');
                                    Get.toNamed(
                                        '/detail_kinerja/${kinerjaData.id_kinerja}',
                                        arguments: kinerjaData);
                                  },
                                  child: ListTile(
                                    title: Text(
                                      monthName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(kinerjaData.tahun,
                                        style: TextStyle(color: Colors.white)),
                                    trailing: Text(
                                      kinerjaData.score_kpi.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ));
                          });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
