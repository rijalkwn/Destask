import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  var isLogin = false;

  @override
  void initState() {
    super.initState();
    startLaunching();
  }

  startLaunching() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    if (token != null) {
      setState(() {
        isLogin = true;
      });
    }

    // Timer(const Duration(seconds: 1), () {
    //   if (!isLogin) {
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
    //         builder: (BuildContext context) => const Login()));
    //   }
    // });
  }

  List names = [
    "Total Pekerjaan",
    "Target Bulan Ini",
    "Task Selesai",
  ];

  List<Color> colors = [
    Colors.amberAccent,
    Colors.greenAccent,
    Colors.purple,
  ];

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
  List pekerjaan = [
    "Lorem Ipsum sadajsdn sdskadas asdans as",
    "Lorem sds adsdasda sdda a asdsa asaas asdadadsdas",
    "ffijic wjiejfie fejiejf efei jfwijfw",
    "Lo isdiaj ajdisjd aisdi asdjisad asidaid asdasi",
    "eurhce rija lkruna aaksd asdasda adaaa asa",
    "Lorem Ipsum sadajsdn sdskadas asdans as",
  ];

  List status = [
    "ON PROGRESS",
    "ON PROGRESS",
    "ON PROGRESS",
    "ON PROGRESS",
    "ON PROGRESS",
    "ON PROGRESS",
  ];
  List PM = [
    "Rijal Kurniawan",
    "Agung Nugraha",
    "Rijal Kurniawan",
    "Agung Nugraha",
    "Rijal Kurniawan",
    "Agung Nugraha",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            _Header(),
            _JobList(),
          ],
        ),
      ),
    );
  }

  Container _Header() {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
      decoration: const BoxDecoration(
        //gunakan global color
        color: Colors.blueAccent,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                    color: Colors.lightBlue[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: GridView.builder(
              itemCount: names.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: colors[index],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: nameIcon[index],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 2,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red, // Adjust color as needed
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              (index + 1)
                                  .toString(), // Display the index as a number
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
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
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 20),
            width: MediaQuery.of(context).size.width,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: "Search here...",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _JobList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          //gunakan global color
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "ON PROGRESS",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              _ListOfJob(pekerjaan: pekerjaan, status: status, PM: PM),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListOfJob extends StatelessWidget {
  const _ListOfJob({
    super.key,
    required this.pekerjaan,
    required this.status,
    required this.PM,
  });

  final List pekerjaan;
  final List status;
  final List PM;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: pekerjaan.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //card berbentuk listtile dengan tiap card dapat di tap
          return GestureDetector(
            onTap: () {
              //bottomsheet
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(pekerjaan[index]),
                          subtitle: Text(status[index]),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Card(
              color: PM[index] == "RijaL Kurniawan"
                  ? Colors.cyan[200]
                  : Colors.amber[200],
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.work,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                trailing: Container(
                  child: Text(
                    status[index],
                    textAlign: TextAlign.end,
                  ),
                ),
                title: Text(
                  pekerjaan[index].length > 20
                      ? '${pekerjaan[index].substring(0, 20)}...'
                      : pekerjaan[index],
                ),
                subtitle: Text("PM : " + PM[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
