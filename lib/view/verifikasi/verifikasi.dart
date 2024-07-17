import 'package:destask/controller/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/pekerjaan_controller.dart';
import '../../model/pekerjaan_model.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verifikasi extends StatefulWidget {
  const Verifikasi({super.key});

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  PekerjaanController pekerjaanController = PekerjaanController();
  UserController userController = UserController();
  late Future<List<PekerjaanModel>> pekerjaanVerifikasi;
  late Future<List<PekerjaanModel>> pekerjaanVerifikasiDone;
  bool isSearchBarVisible = false;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });
    pekerjaanVerifikasi = pekerjaanverifikasitask();
    pekerjaanVerifikasiDone = pekerjaanverifikasitaskdone();
  }

  Future<List<PekerjaanModel>> pekerjaanverifikasitask() async {
    var data = await pekerjaanController.getPekerjaanVerifikasi();
    return data;
  }

  Future<List<PekerjaanModel>> pekerjaanverifikasitaskdone() async {
    var data = await pekerjaanController.getPekerjaanVerifikator();
    return data;
  }

  @override
  void dispose() {
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
            : const Text('Verifikasi', style: TextStyle(color: Colors.white)),
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
          tabs: const [
            Tab(icon: Icon(Icons.library_books), text: 'Perlu Verifikasi'),
            Tab(icon: Icon(Icons.verified), text: 'Sudah Verifikasi'),
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
          ViewPekerjaan(
            pekerjaan: pekerjaanVerifikasi,
            index: selectedTabIndex,
            searchQuery: searchController.text,
            onDismissed: () {
              setState(() {
                pekerjaanVerifikasi = pekerjaanverifikasitask();
              });
            },
          ),
          ViewPekerjaan(
            pekerjaan: pekerjaanVerifikasiDone,
            index: selectedTabIndex,
            searchQuery: searchController.text,
            onDismissed: () {
              setState(() {
                pekerjaanVerifikasiDone = pekerjaanverifikasitaskdone();
              });
            },
          ),
        ],
      ),
    );
  }
}

class ViewPekerjaan extends StatelessWidget {
  const ViewPekerjaan({
    Key? key,
    required this.pekerjaan,
    required this.index,
    required this.searchQuery,
    required this.onDismissed,
  }) : super(key: key);

  final Future<List<PekerjaanModel>> pekerjaan;
  final int index;
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
                .where((pekerjaan) => pekerjaan.nama_pekerjaan!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList();

            if (filteredList.isEmpty) {
              return const Center(child: Text('Data Pada Status Ini Kosong'));
            }

            return PekerjaanList(
              pekerjaan: filteredList,
              tabIndex: index,
              refresh: onDismissed,
            );
          } else {
            return const Center(child: Text('Data Kosong'));
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
    required this.pekerjaan,
    required this.tabIndex,
    required this.refresh,
  }) : super(key: key);

  final List<PekerjaanModel> pekerjaan;
  final int tabIndex;
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
        return Card(
          color: GlobalColors.mainColor,
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
              pekerjaan[index].nama_pekerjaan!.length > 45
                  ? '${pekerjaan[index].nama_pekerjaan!.substring(0, 45)}...'
                  : pekerjaan[index].nama_pekerjaan!,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: Text(
              pekerjaan[index].data_tambahan.project_manager.isNotEmpty
                  ? "PM: ${pekerjaan[index].data_tambahan.project_manager[0].nama!.length > 25 ? pekerjaan[index].data_tambahan.project_manager[0].nama!.substring(0, 25) + '...' : pekerjaan[index].data_tambahan.project_manager[0].nama!}"
                  : "PM: -",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            trailing: GestureDetector(
              onTap: () {
                Get.toNamed(
                    '/detail_pekerjaan/${pekerjaan[index].id_pekerjaan}');
              },
              child: const Icon(
                Icons.density_medium,
                color: Colors.white,
              ),
            ),
            onTap: () {
              if (tabIndex == 0) {
                Get.toNamed(
                    '/verifikasi_task/${pekerjaan[index].id_pekerjaan}');
              } else {
                Get.toNamed(
                    '/verifikasi_task_done/${pekerjaan[index].id_pekerjaan}');
              }
            },
          ),
        );
      },
    );
  }
}
