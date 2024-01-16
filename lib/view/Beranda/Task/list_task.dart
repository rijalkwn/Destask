import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/Beranda/Task/detail_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ListTask extends StatefulWidget {
  const ListTask({Key? key}) : super(key: key);

  @override
  _ListTaskState createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  bool isSearchBarVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GlobalColors.mainColor, // Ubah warna sesuai preferensi Anda
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
            : Text('Pekerjaan',
                style: TextStyle(
                    color: Colors.white)), // Ubah warna teks sesuai kebutuhan
        iconTheme: IconThemeData(color: Colors.white),
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
          tabs: const [
            Tab(text: 'Planning'),
            Tab(text: 'Hari Ini'),
            Tab(text: 'Over Due'),
          ],
          labelStyle: TextStyle(fontSize: 17), // Ukuran teks tab yang dipilih
          unselectedLabelStyle: TextStyle(fontSize: 16),
          indicatorColor: Colors.white, // Warna underline/tab indicator
          labelColor: Colors.white, // Warna teks tab yang dipilih
          unselectedLabelColor: Colors.blue.shade100,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TaskList(tasks: todoTasks),
          TaskList(tasks: inProgressTasks),
          TaskList(tasks: doneTasks),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi ketika tombol "Add" ditekan
          // Misalnya, navigasi ke halaman tambah task
          Get.toNamed('/kelola_task');
        },
        backgroundColor: GlobalColors.mainColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<String> tasks;

  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
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
                tasks[index],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'Deskripsi tugas',
                style: TextStyle(fontSize: 12),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.work, color: Colors.white),
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Aksi ketika tombol ditekan
                },
              ),
              onTap: () {
                // Navigasi ke halaman detail ketika item ditekan
                Get.toNamed('/detail_task', arguments: tasks[index]);
              },
            ),
          ),
        );
      },
    );
  }
}

// Sample task lists for demonstration purposes
List<String> todoTasks = [
  'Task 1 - To Do',
  'Task 2 - To Do',
  'Task 1 - To Do',
  'Task 2 - To Do',
  'Task 1 - To Do',
  'Task 2 - To Do',
  'Task 1 - To Do',
  'Task 2 - To Do',
  'Task 1 - To Do',
  'Task 2 - To Do',
  'Task 1 - To Do',
  'Task 2 - To Do',
  'Task 1 - To Do',
  'Task 2 - To Do',
  'Task 1 - To Do',
  'Task 2 - To Do',
  'Task 1 - To Do',
  'Task 2 - To Do',

  // Add more tasks as needed
];

List<String> inProgressTasks = [
  'Task 3 - In Progress',
  'Task 4 - In Progress',
  // Add more tasks as needed
];

List<String> doneTasks = [
  'Task 5 - Done',
  'Task 6 - Done',
  // Add more tasks as needed
];
