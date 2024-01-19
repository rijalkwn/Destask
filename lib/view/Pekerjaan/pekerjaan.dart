import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/model/pekerjaan_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/Beranda/Task/list_task.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pekerjaan extends StatefulWidget {
  const Pekerjaan({Key? key}) : super(key: key);

  @override
  _PekerjaanState createState() => _PekerjaanState();
}

class _PekerjaanState extends State<Pekerjaan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<dynamic>> futurePekerjaan;
  TextEditingController searchController = TextEditingController();
  PekerjaanController pekerjaanController = PekerjaanController();

  final List<String> statusNames = [
    'On Progress',
    'Selesai',
    'Pending',
    'Cancel',
    'Bast',
    'Support',
  ];
  //icon
  final List<IconData> statusIcon = [
    Icons.work,
    Icons.check_circle,
    Icons.pending,
    Icons.cancel,
    Icons.assignment,
    Icons.support,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    futurePekerjaan = PekerjaanController().getAllPekerjaan();
  }

  bool isSearchBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: isSearchBarVisible
            ? TextField(
                controller: searchController,
                style: TextStyle(color: Colors.white),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                      });
                    },
                  ),
                ),
              )
            : Text('Pekerjaan', style: TextStyle(color: Colors.white)),
        actions: !isSearchBarVisible
            ? [
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      isSearchBarVisible = !isSearchBarVisible;
                    });
                  },
                ),
              ]
            : null,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 10),
          tabs: [
            for (var i = 0; i < statusNames.length; i++)
              Tab(
                icon: Icon(statusIcon[i]),
                text: statusNames[i],
              ),
          ],
          labelStyle: TextStyle(fontSize: 17),
          unselectedLabelStyle: TextStyle(fontSize: 16),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.blue[100],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (var status in statusNames)
            StatusPekerjaan(
              futurePekerjaan: futurePekerjaan,
              status: status,
            ),
        ],
      ),
    );
  }
}

class StatusPekerjaan extends StatelessWidget {
  const StatusPekerjaan({
    Key? key,
    required this.futurePekerjaan,
    required this.status,
  }) : super(key: key);

  final Future<List<dynamic>> futurePekerjaan;
  final String status;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futurePekerjaan,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available.'));
        } else if (snapshot.hasData) {
          final filteredList = snapshot.data!
              .where((pekerjaan) => pekerjaan['status'] == status)
              .toList();

          return PekerjaanList(
            status: status,
            pekerjaanData: filteredList,
          );
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    );
  }
}

class PekerjaanList extends StatelessWidget {
  final String status;
  final List<dynamic> pekerjaanData;

  PekerjaanList({required this.status, required this.pekerjaanData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pekerjaanData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Get.to(ListTask(idpekerjaan: pekerjaanData[index]['idpekerjaan']));
          },
          child: Card(
            color: GlobalColors.mainColor,
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
                pekerjaanData[index]['nama_pekerjaan'].length > 20
                    ? '${pekerjaanData[index]['nama_pekerjaan'].substring(0, 20)}...'
                    : pekerjaanData[index]['nama_pekerjaan'],
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "PM : " + pekerjaanData[index]['PM'],
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
                    pekerjaanData[index]['tanggal_selesai'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
