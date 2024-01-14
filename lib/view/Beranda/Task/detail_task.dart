import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';

class DetailTask extends StatefulWidget {
  const DetailTask({Key? key}) : super(key: key);

  @override
  _DetailTaskState createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GlobalColors.mainColor, // Ubah warna sesuai preferensi Anda
        title: const Text('Nama Pekerjaan',
            style: TextStyle(
                color: Colors.white)), // Ubah warna teks sesuai kebutuhan
        iconTheme: IconThemeData(color: Colors.white),
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
                backgroundColor: Colors.blue, // Warna lingkaran sebelah kiri
                child: Icon(Icons.work,
                    color: Colors.white), // Ikon di dalam lingkaran
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert), // Ikon di sebelah kanan
                onPressed: () {
                  // Aksi ketika tombol ditekan
                },
              ),
              onTap: () {
                // Aksi ketika list tile ditekan
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
