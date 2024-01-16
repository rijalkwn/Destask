import 'package:destask/utils/global_colors.dart';
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
  TextEditingController searchController = TextEditingController();

  // Map to associate each tab with its corresponding list of tasks
  final Map<String, List<String>> tabData = {
    'On Progress': OnProgress,
    'Selesai': Selesai,
    'Pending': Pending,
    'Cancel': Cancel,
    'Bast': Bast,
    'Support': Support,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelPadding: EdgeInsets.symmetric(horizontal: 10), // padding tab
            tabs: const [
              Tab(icon: Icon(Icons.work), text: 'On Progress'),
              Tab(icon: Icon(Icons.check_circle), text: 'Selesai'),
              Tab(icon: Icon(Icons.pending), text: 'Pending'),
              Tab(icon: Icon(Icons.cancel), text: 'Cancel'),
              Tab(icon: Icon(Icons.support), text: 'Support'),
              Tab(icon: Icon(Icons.assignment), text: 'Bast'),
            ],
            labelStyle: TextStyle(fontSize: 17), // Ukuran teks tab yang dipilih
            unselectedLabelStyle: TextStyle(fontSize: 16),
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blue[100],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabData.keys.map((tab) {
          return PekerjaanList(
            pekerjaans: tabData[tab] ?? [],
            tabController: _tabController,
            tabData: tabData,
          );
        }).toList(),
      ),
    );
  }
}

class PekerjaanList extends StatelessWidget {
  final List<String> pekerjaans;
  final TabController tabController;
  final Map<String, List<String>> tabData;

  const PekerjaanList({
    Key? key,
    required this.pekerjaans,
    required this.tabController,
    required this.tabData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: pekerjaans.length,
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
                  pekerjaans[index],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  'Project Manager',
                  style: TextStyle(fontSize: 12),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue, // Warna lingkaran sebelah kiri
                  child: Icon(Icons.work,
                      color: Colors.white), // Ikon di dalam lingkaran
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert), // Ikon di sebelah kanan
                  onPressed: () {},
                ),
                onTap: () {
                  Get.toNamed('list_task');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Sample task lists for demonstration purposes
List<String> OnProgress = [
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',
  'Pekerjaan 1 - To Do',
  'Pekerjaan 2 - To Do',

  // Add more Pekerjaans as needed
];

List<String> Selesai = [
  'Pekerjaan 3 - In Progress',
  'Pekerjaan 4 - In Progress',
  // Add more Pekerjaans as needed
];

List<String> Pending = [
  'Pekerjaan 5 - Done',
  'Pekerjaan 6 - Done',
  // Add more Pekerjaans as needed
];
List<String> Cancel = [
  'Pekerjaan 5 - Done',
  'Pekerjaan 6 - Done',
  // Add more Pekerjaans as needed
];
List<String> Bast = [
  'Pekerjaan 5 - Done',
  'Pekerjaan 6 - Done',
  // Add more Pekerjaans as needed
];
List<String> Support = [
  'Pekerjaan 5 - Done',
  'Pekerjaan 6 - Done',
  // Add more Pekerjaans as needed
];

List category = [
  "On Progress",
  "Selesai",
  "Pending",
  "Cancel",
  "Support",
  "Bast"
];
List names = [
  "Total Pekerjaan",
  "Target Bulan Ini",
  "Task Selesai",
];

List<Color> colors = [
  Colors.orangeAccent,
  Colors.green,
  Colors.redAccent,
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
