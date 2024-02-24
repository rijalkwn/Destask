import '../../../controller/pekerjaan_controller.dart';
import '../../../model/pekerjaan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/global_colors.dart';

class PekerjaanSelesai extends StatefulWidget {
  const PekerjaanSelesai({super.key});

  @override
  State<PekerjaanSelesai> createState() => _PekerjaanSelesaiState();
}

class _PekerjaanSelesaiState extends State<PekerjaanSelesai> {
  TextEditingController searchController = TextEditingController();
  PekerjaanController pekerjaanController = PekerjaanController();
  bool isSearchBarVisible = false;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isSearchBarVisible
            ? TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
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
                          searchQuery = "";
                        } else {
                          isSearchBarVisible = false;
                        }
                      });
                    },
                  ),
                ),
              )
            : const Text('Pekerjaan Selesai',
                style: TextStyle(color: Colors.white)),
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
      body: FutureBuilder(
        future: pekerjaanController.getAllPekerjaanUser(),
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
                    pekerjaan.id_status_pekerjaan == "2" &&
                    pekerjaan.persentase_selesai == "100" &&
                    pekerjaan.waktu_selesai != null &&
                    pekerjaan.nama_pekerjaan!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();

            return PekerjaanList(
              pekerjaan: filteredList,
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}

class PekerjaanList extends StatelessWidget {
  final List<dynamic> pekerjaan;

  const PekerjaanList({super.key, required this.pekerjaan});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pekerjaan.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 3, left: 5, right: 5),
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
                "Persentase Selesai : ${pekerjaan[index].persentase_selesai}%",
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
