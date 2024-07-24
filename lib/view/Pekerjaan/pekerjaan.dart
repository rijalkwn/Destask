import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/status_pekerjaan_controller.dart';
import 'package:destask/model/pekerjaan_model.dart';
import 'package:destask/model/status_pekerjaan_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pekerjaan extends StatefulWidget {
  const Pekerjaan({super.key});

  @override
  State<Pekerjaan> createState() => _PekerjaanState();
}

class _PekerjaanState extends State<Pekerjaan> with TickerProviderStateMixin {
  late TabController _tabController;
  StatusPekerjaanController statusPekerjaanController =
      StatusPekerjaanController();
  PekerjaanController pekerjaanController = PekerjaanController();
  late Future<List<StatusPekerjaanModel>> statusPekerjaan;
  late Future<List<PekerjaanModel>> pekerjaan;
  TextEditingController searchController = TextEditingController();
  bool isSearchBarVisible = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    statusPekerjaan = getStatusPekerjaan();
    pekerjaan = getDataPekerjaan();
  }

  refresh() async {
    setState(() {
      statusPekerjaan = getStatusPekerjaan();
      pekerjaan = getDataPekerjaan();
    });
  }

  //status pekerjaan
  Future<List<StatusPekerjaanModel>> getStatusPekerjaan() async {
    var data = await statusPekerjaanController.getAllStatusPekerjaan();
    return data;
  }

  // get data pekerjaan
  Future<List<PekerjaanModel>> getDataPekerjaan() async {
    var data = await pekerjaanController.getAllPekerjaanUser();
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
      ),
      body: FutureBuilder<List<StatusPekerjaanModel>>(
        future: statusPekerjaan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gagal memuat data, Silakan tekan tombol refresh untuk mencoba lagi.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      refresh();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          const Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final List<StatusPekerjaanModel> statusData = snapshot.data!;
            _tabController =
                TabController(length: statusData.length, vsync: this);

            return FutureBuilder<List<PekerjaanModel>>(
              future: pekerjaan,
              builder: (context, pekerjaanSnapshot) {
                if (pekerjaanSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 200, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Gagal memuat data, Silakan tekan tombol refresh untuk mencoba lagi.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              statusPekerjaan = getStatusPekerjaan();
                              pekerjaan = getDataPekerjaan();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                const Text(
                                  'Refresh',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (!pekerjaanSnapshot.hasData ||
                    pekerjaanSnapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<PekerjaanModel> pekerjaanData = pekerjaanSnapshot.data!;

                  return Column(
                    children: [
                      TabBar(
                        indicatorColor: GlobalColors.mainColor,
                        unselectedLabelColor: Colors.black,
                        dividerColor: GlobalColors.mainColor,
                        labelColor: GlobalColors.mainColor,
                        controller: _tabController,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: statusData.map((status) {
                          return Tab(text: status.nama_status_pekerjaan);
                        }).toList(),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: statusData.map((status) {
                            final filterPekerjaan = pekerjaanData
                                .where((pekerjaan) =>
                                    pekerjaan.id_status_pekerjaan ==
                                    status.id_status_pekerjaan)
                                .where((pekerjaan) =>
                                    pekerjaan.nama_pekerjaan
                                        .toLowerCase()
                                        .contains(
                                          searchController.text.toLowerCase(),
                                        ) ||
                                    pekerjaan.data_tambahan.project_manager
                                        .toString()
                                        .contains(searchController.text))
                                .toList();

                            if (filterPekerjaan.isEmpty) {
                              return Center(
                                  child: Text('Tidak ada data pekerjaan'));
                            }

                            return ListView.builder(
                              itemCount: filterPekerjaan.length,
                              itemBuilder: (context, index) {
                                final pekerjaan = filterPekerjaan[index];
                                return Card(
                                  color: Color(int.parse(
                                      '0xff${status.color.replaceAll('#', '')}')),
                                  child: ListTile(
                                    leading: Container(
                                      width: 50, // Set fixed width
                                      height: 50, // Set fixed height
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${_formatPercentage(pekerjaan.data_tambahan.persentase_task_selesai)}%",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      pekerjaan.nama_pekerjaan!.length > 45
                                          ? '${pekerjaan.nama_pekerjaan!.substring(0, 45)}...'
                                          : pekerjaan.nama_pekerjaan!,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    subtitle: Text(
                                      pekerjaan.data_tambahan.project_manager
                                              .isNotEmpty
                                          ? "PM: ${pekerjaan.data_tambahan.project_manager[0].nama.length > 25 ? '${pekerjaan.data_tambahan.project_manager[0].nama.substring(0, 25)}...' : pekerjaan.data_tambahan.project_manager[0].nama}"
                                          : "PM: -",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                            '/detail_pekerjaan/${pekerjaan.id_pekerjaan}');
                                      },
                                      child: const Icon(
                                        Icons.density_medium,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Get.toNamed(
                                          '/task/${pekerjaan.id_pekerjaan}');
                                    },
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  String _formatPercentage(String percentage) {
    if (percentage == '100.0') {
      return '100';
    } else {
      return percentage;
    }
  }
}
