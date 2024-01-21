import 'dart:async';

import 'package:badges/badges.dart';
import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/lo.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Testing extends StatefulWidget {
  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  var isLogin = false;
  PekerjaanController pekerjaanController = PekerjaanController();
  late Future<List> futurePekerjaan;

  @override
  void initState() {
    super.initState();
    startLaunching();
    futurePekerjaan = pekerjaanController.getOnProgress();
  }

  startLaunching() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    if (token != null) {
      setState(() {
        isLogin = true;
      });
    }

    Timer(const Duration(seconds: 1), () {
      if (!isLogin) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => const Lo()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    DateTime currentDate = DateTime.now();
    String dayOfWeek = _getDayOfWeek(currentDate.weekday);
    String formattedDate =
        "${currentDate.day} ${_getMonth(currentDate.month)} ${currentDate.year}";
    return Scaffold(
      body: Stack(
        children: [
          // Kotak Merah
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight / 3,
              color: GlobalColors.mainColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 45),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, Rijal Kurniawan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                wordSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Selamat Datang Di Destask",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/notifikasi');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: badges.Badge(
                              badgeContent: Text(
                                '3',
                                style: TextStyle(color: Colors.white),
                              ),
                              badgeStyle: BadgeStyle(
                                  badgeColor: Colors.red, // Red circle color
                                  elevation: 4, // No shadow
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 5, right: 5)),
                              child: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayOfWeek,',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(top: 5, bottom: 20),
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 45,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: TextFormField(
                    //     decoration: const InputDecoration(
                    //       border: InputBorder.none,
                    //       prefixIcon: Icon(
                    //         Icons.search,
                    //         color: Colors.grey,
                    //       ),
                    //       hintText: "Search here...",
                    //       hintStyle: TextStyle(
                    //         color: Colors.grey,
                    //         fontSize: 18,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          // Kotak Biru
          Positioned(
            top: screenHeight / 4.1,
            left: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight * 3 / 4,
              color: Colors.white,
              child: SingleChildScrollView(
                child: FutureBuilder<List<dynamic>>(
                  future: futurePekerjaan,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      List<dynamic> pekerjaan = snapshot.data as List<dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "ON PROGRESS",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalColors
                                      .textColor, // Choose your desired text color
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _ListOfJob(pekerjaan: pekerjaan),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          // Kotak Kuning di Tengah
          Positioned(
            top: screenHeight / 6 - 8.0,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: screenWidth / 1.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightBlue[300],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: GridView.builder(
                      itemCount: names.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            badges.Badge(
                              badgeContent: Text('3',
                                  style: TextStyle(color: Colors.white)),
                              badgeStyle: BadgeStyle(
                                badgeColor: Colors.red, // Red circle color
                                elevation: 0, // No shadow
                                padding: EdgeInsets.all(
                                    10), // Padding around the badge content
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colors[index],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: nameIcon[index],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              names[index],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: pekerjaan.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var namaPekerjaan = pekerjaan[index].nama_pekerjaan;
          var PM = pekerjaan[index].PM;
          return InkWell(
            onTap: () {
              Get.toNamed('/task/${pekerjaan[index].idpekerjaan}');
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                color: PM == "Rijal Kurniawan"
                    ? Colors.green
                    : GlobalColors.mainColor,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.work,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    namaPekerjaan.length > 20
                        ? '${namaPekerjaan.substring(0, 20)}...'
                        : namaPekerjaan,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "PM : " + PM,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Deadline",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        pekerjaan[index].tanggal_selesai,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

List<Color> colors = [
  Colors.amber,
  Colors.green,
  Colors.purple,
];

List<String> names = ['Total Pekerjaan', 'Target Bulan Ini', 'Task Selesai'];

List<Icon> nameIcon = const [
  Icon(
    Icons.work,
    size: 30,
    color: Colors.white,
  ),
  Icon(
    Icons.calendar_today,
    size: 30,
    color: Colors.white,
  ),
  Icon(
    Icons.check_circle,
    size: 30,
    color: Colors.white,
  ),
];

String _getDayOfWeek(int day) {
  switch (day) {
    case 1:
      return 'Senin';
    case 2:
      return 'Selasa';
    case 3:
      return 'Rabu';
    case 4:
      return 'Kamis';
    case 5:
      return 'Jumat';
    case 6:
      return 'Sabtu';
    case 7:
      return 'Minggu';
    default:
      return '';
  }
}

String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'Januari';
    case 2:
      return 'Februari';
    case 3:
      return 'Maret';
    case 4:
      return 'April';
    case 5:
      return 'Mei';
    case 6:
      return 'Juni';
    case 7:
      return 'Juli';
    case 8:
      return 'Agustus';
    case 9:
      return 'September';
    case 10:
      return 'Oktober';
    case 11:
      return 'November';
    case 12:
      return 'Desember';
    default:
      return '';
  }
}
