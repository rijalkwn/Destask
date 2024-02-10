import 'package:destask/controller/user_controller.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/pekerjaan_controller.dart';
import '../../model/pekerjaan_model.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pekerjaan extends StatefulWidget {
  const Pekerjaan({super.key});

  @override
  State<Pekerjaan> createState() => _PekerjaanState();
}

class _PekerjaanState extends State<Pekerjaan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  PekerjaanController pekerjaanController = PekerjaanController();
  UserController userController = UserController();
  late Future<List<PekerjaanModel>> pekerjaan;
  bool isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    pekerjaan = getDataPekerjaan();
  }

  // get data pekerjaan
  Future<List<PekerjaanModel>> getDataPekerjaan() async {
    var data = await pekerjaanController.getAllPekerjaanUser();
    return data;
  }

  @override
  void dispose() {
    // Dispose controllers
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: isSearchBarVisible
            ? TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchController.text = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (searchController.text.isNotEmpty) {
                          searchController.clear();
                        } else {
                          isSearchBarVisible = false;
                        }
                      });
                    },
                  ),
                ),
              )
            : const Text('Pekerjaan', style: TextStyle(color: Colors.white)),
        actions: !isSearchBarVisible
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
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
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          tabs: [
            for (var i = 0; i < statusNames.length; i++)
              Tab(
                icon: Icon(statusIcon[i]),
                text: statusNames[i],
              ),
          ],
          labelStyle: const TextStyle(fontSize: 17),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.blue[100],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (var status in statusId)
            StatusPekerjaan(
              pekerjaan: pekerjaan,
              status: status,
              searchQuery: searchController.text,
              onDismissed: () {
                setState(() {
                  pekerjaan =
                      getDataPekerjaan(); // Ambil data pekerjaan kembali
                });
              },
            ),
        ],
      ),
    );
  }
}

class StatusPekerjaan extends StatelessWidget {
  const StatusPekerjaan(
      {Key? key,
      required this.pekerjaan,
      required this.status,
      required this.searchQuery,
      required this.onDismissed})
      : super(key: key);

  final Future<List<PekerjaanModel>> pekerjaan;
  final String status;
  final String searchQuery;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PekerjaanModel>>(
      future: pekerjaan,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available.'));
        } else if (snapshot.hasData) {
          List<PekerjaanModel> pekerjaan = snapshot.data!;
          final filteredList = pekerjaan
              .where((pekerjaan) =>
                  pekerjaan.id_status_pekerjaan == status &&
                  pekerjaan.nama_pekerjaan!
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
              .toList();

          return PekerjaanList(
            status: status,
            pekerjaan: filteredList,
            refresh: onDismissed,
          );
        } else {
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }
}

@immutable
class PekerjaanList extends StatelessWidget {
  const PekerjaanList({
    super.key,
    required this.status,
    required this.pekerjaan,
    required this.refresh,
  });

  final String status;
  final List<PekerjaanModel> pekerjaan;
  final VoidCallback refresh;

  getId() async {
    var pref = await SharedPreferences.getInstance();
    var id = pref.getString('id_user');
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pekerjaan.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(pekerjaan[index].id_pekerjaan.toString()),
          direction: DismissDirection.horizontal, // Tetapkan arah ke horizontal
          background: Container(
            color: Colors.green, // Warna latar belakang saat digeser
            alignment: Alignment.centerLeft, // Geser ke kiri
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.check,
                color: Colors.white), // Icon untuk menandakan "Selesai"
          ),
          secondaryBackground: Container(
            color: Colors
                .green, // Warna latar belakang saat digeser ke arah sebaliknya
            alignment: Alignment.centerRight, // Geser ke kanan
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.cancel,
                color: Colors.white), // Icon untuk menandakan "Cancel"
          ),
          onDismissed: (direction) async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text(
                      'Apakah Anda yakin ingin memindahkan pekerjaan ini?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog
                      },
                      child: const Text('Tidak'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Tutup dialog
                        final idUser = await getId();
                        if (direction == DismissDirection.startToEnd) {
                          //cek id status pekerjaan
                          int nextStatus;
                          if (status == '6') {
                            nextStatus = 1;
                          } else {
                            nextStatus = int.parse(status) + 1;
                          }
                          //cek pm
                          if (pekerjaan[index].data_tambahan.id_user_pm ==
                              idUser) {
                            PekerjaanController().updateStatusPekerjaan(
                                pekerjaan[index].id_pekerjaan!,
                                nextStatus.toString());
                            QuickAlert.show(
                                context: context,
                                title: "Pekerjaan Berhasil Dipindahkan",
                                type: QuickAlertType.success);
                          } else {
                            QuickAlert.show(
                                context: context,
                                title: "Anda Bukan PM",
                                type: QuickAlertType.error);
                          }
                        } else if (direction == DismissDirection.endToStart) {
                          //cek id status pekerjaan
                          int prevStatus;
                          if (status == '1') {
                            prevStatus = 6;
                          } else {
                            prevStatus = int.parse(status) - 1;
                          }
                          //cek pm
                          if (pekerjaan[index].data_tambahan.id_user_pm ==
                              idUser) {
                            PekerjaanController().updateStatusPekerjaan(
                                pekerjaan[index].id_pekerjaan!,
                                prevStatus.toString());
                            QuickAlert.show(
                                context: context,
                                title: "Pekerjaan Berhasil Dipindahkan",
                                type: QuickAlertType.success);
                          } else {
                            QuickAlert.show(
                                context: context,
                                title: "Anda Bukan PM",
                                type: QuickAlertType.error);
                          }
                        }
                        refresh(); // Panggil fungsi refresh setelah melakukan pemindahan
                      },
                      child: const Text('Ya'),
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            color: GlobalColors.mainColor,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${pekerjaan[index].persentase_selesai}%',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              title: Text(
                pekerjaan[index].nama_pekerjaan ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "PM: ${pekerjaan[index].data_tambahan.nama_pm}",
                style: const TextStyle(color: Colors.white),
              ),
              trailing: GestureDetector(
                onTap: () {
                  Get.toNamed(
                      '/detail_pekerjaan/${pekerjaan[index].id_pekerjaan}');
                },
                child: const Icon(
                  Icons.density_small,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Get.toNamed('/task/${pekerjaan[index].id_pekerjaan}');
              },
            ),
          ),
        );
      },
    );
  }
}

final List<String> statusId = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
];

final List<String> statusNames = [
  'On Progress',
  'Selesai',
  'Pending',
  'Cancel',
  'Bast',
  'Support'
];

final List<IconData> statusIcon = [
  Icons.work,
  Icons.check_circle,
  Icons.pending,
  Icons.cancel,
  Icons.assignment,
  Icons.support,
];
