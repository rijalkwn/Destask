import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KPI extends StatefulWidget {
  @override
  State<KPI> createState() => _KPIState();
}

class _KPIState extends State<KPI> {
  List<Map<String, dynamic>> kpiList = [
    {
      "month": "Januari",
      "year": 2024,
      "target": 100,
      "realisasi": 30,
    },
    {
      "month": "Februari",
      "year": 2024,
      "target": 100,
      "realisasi": 100,
    },
    {
      "month": "Maret",
      "year": 2024,
      "target": 100,
      "realisasi": 120,
    },
    // Tambahkan bulan dan pekerjaan sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Key Performance Indicator',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: kpiList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    '${kpiList[index]["month"]} ${kpiList[index]["year"]}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Realisasi : ${kpiList[index]["realisasi"].toString()}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Target : ${kpiList[index]["target"].toString()}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.score, color: Colors.white),
                  ),
                  trailing: _buildTrailingWidget(
                      kpiList[index]["target"], kpiList[index]["realisasi"]),
                  onTap: () {},
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrailingWidget(int target, int realisasi) {
    IconData iconData;
    Color color;

    if (realisasi < target) {
      iconData = Icons.thumb_down; // Target terlampau
      color = Colors.red;
    } else if (realisasi == target) {
      iconData = Icons.thumbs_up_down_sharp; // Target sama dengan realisasi
      color = Colors.orange;
    } else if (realisasi > target) {
      iconData = Icons.thumb_up; // Target tercapai
      color = Colors.green;
    } else {
      iconData = Icons.error; // Error
      color = Colors.red;
    }

    return Icon(
      iconData,
      color: color,
    );
  }
}
