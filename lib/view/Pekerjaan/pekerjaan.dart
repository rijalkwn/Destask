import 'package:destask/controller/status_pekerjaan_controller.dart';
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
  StatusPekerjaanController statusPekerjaanController =
      StatusPekerjaanController();
  UserController userController = UserController();
  late Future<List<PekerjaanModel>> pekerjaan;
  bool isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    pekerjaan = getDataPekerjaan();
  }

  // get data pekerjaan
  Future<List<PekerjaanModel>> getDataPekerjaan() async {
    var data = await pekerjaanController.getAllPekerjaanUser();
    return data;
  }

  //status pekerjaan
  Future getStatusPekerjaan() async {
    var data = await statusPekerjaanController.getAllStatusPekerjaan();
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
          labelPadding: const EdgeInsets.symmetric(horizontal: 1),
          tabs: [
            for (var i = 0; i < statusId.length; i++)
              Tab(
                icon: Icon(statusIcon[i]),
                text: statusNames[i],
              ),
          ],
          labelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
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
    return Container(
      child: FutureBuilder<List<PekerjaanModel>>(
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
      ),
    );
  }
}

@immutable
class PekerjaanList extends StatelessWidget {
  const PekerjaanList({
    Key? key,
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
          direction: DismissDirection.horizontal,
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.check, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.green,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.cancel, color: Colors.white),
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
                        Navigator.of(context).pop();
                      },
                      child: const Text('Tidak'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final idUser = await getId();
                        if (direction == DismissDirection.startToEnd) {
                          int nextStatus;
                          if (status == '5') {
                            nextStatus = 1;
                          } else {
                            nextStatus = int.parse(status) + 1;
                          }
                          if (pekerjaan[index].data_tambahan.pm.isNotEmpty &&
                              pekerjaan[index].data_tambahan.pm[0].id_user ==
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
                          int prevStatus;
                          if (status == '1') {
                            prevStatus = 5;
                          } else {
                            prevStatus = int.parse(status) - 1;
                          }
                          if (pekerjaan[index].data_tambahan.pm.isNotEmpty &&
                              pekerjaan[index].data_tambahan.pm[0].id_user ==
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
                        refresh();
                      },
                      child: const Text('Ya'),
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            color: color[int.parse(status) - 1],
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${pekerjaan[index].data_tambahan.persentase_task_selesai}%',
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
              subtitle: pekerjaan[index].data_tambahan.pm.isNotEmpty
                  ? Text(
                      "PM: ${pekerjaan[index].data_tambahan.pm[0].nama}",
                      style: const TextStyle(color: Colors.white),
                    )
                  : Text(
                      "PM: -",
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
];

final List<String> statusNames = [
  'Presales',
  'On Progress',
  'Bast',
  'Support',
  'Cancel',
];

final List<Color> color = [
  const Color(0xFFfd7e14),
  const Color(0xFFffc107),
  const Color(0xFF198754),
  const Color(0xFF0d6efd),
  const Color(0xFFdc3545),
];

final List<IconData> statusIcon = [
  Icons.timer,
  Icons.check_circle,
  Icons.assignment,
  Icons.support,
  Icons.cancel,
];
