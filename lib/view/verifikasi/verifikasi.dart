import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/model/pekerjaan_model.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verifikasi extends StatefulWidget {
  const Verifikasi({Key? key}) : super(key: key);

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  PekerjaanController pekerjaanController = PekerjaanController();
  late Future<List<PekerjaanModel>> pekerjaan;

  Future<List<PekerjaanModel>> getPekerjaan() async {
    List<PekerjaanModel> pekerjaan =
        await pekerjaanController.getPekerjaanVerifikasi();
    return pekerjaan;
  }

  @override
  void initState() {
    super.initState();
    pekerjaan = getPekerjaan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Verifikasi',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<PekerjaanModel>>(
          future: pekerjaan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<PekerjaanModel> allPekerjaan = snapshot.data!;
              return ListView.builder(
                itemCount: allPekerjaan.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        '/verifikasi_task/${allPekerjaan[index].id_pekerjaan}',
                        arguments: allPekerjaan[index].id_pekerjaan,
                      );
                    },
                    child: Card(
                      color: GlobalColors.mainColor,
                      child: ListTile(
                        title: Text(
                          allPekerjaan[index].nama_pekerjaan ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'PM: ${allPekerjaan[index].data_tambahan.pm[0].nama}' ??
                              '',
                          style: TextStyle(color: Colors.white),
                        ),
                        // trailing:
                        //     Text(allPekerjaan[index]['status_pekerjaan'] ?? ''),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Tidak ada data'),
              );
            }
          },
        ),
      ),
    );
  }
}
