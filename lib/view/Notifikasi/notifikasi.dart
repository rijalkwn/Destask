import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({Key? key}) : super(key: key);

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  List notifikasi = [
    "Lorem Ipsum sadajsdn sdskadas asdans as",
    "Lorem sds adsdasda sdda a asdsa asaas asdadadsdas",
    "ffijic wjiejfie fejiejf efei jfwijfw",
    "Lo isdiaj ajdisjd aisdi asdjisad asidaid asdasi",
    "eurhce rija lkruna aaksd asdasda adaaa asa",
    "Lorem Ipsum sadajsdn sdskadas asdans as",
  ];
  List detail = [
    "ON PROGRESS",
    "ON PROGRESS",
    "ON PROGRESS",
    "ON PROGRESS",
    "ON PROGRESS",
    "ON PROGRESS",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        //icon
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListView.builder(
          itemCount: notifikasi.length,
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
                              // padding: const EdgeInsets.all(10),
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
                            title: Text(notifikasi[index]),
                            subtitle: Text(detail[index]),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(4),
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
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                  title: Text(
                    notifikasi[index].length > 20
                        ? '${notifikasi[index].substring(0, 20)}...'
                        : notifikasi[index],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
