import '../../controller/notifikasi_controller.dart';
import '../../model/notifikasi_model.dart';
import 'package:flutter/material.dart';

class Notifikasi extends StatefulWidget {
  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  NotifikasiController notifikasiController = NotifikasiController();
  late Future<List<NotifikasiModel>> _notifikasiData;
  //getdata notifikasi
  Future<List<NotifikasiModel>> getDataNotifikasi() async {
    var data = await notifikasiController.getNotifikasi();
    return data;
  }

  @override
  void initState() {
    super.initState();
    _notifikasiData = getDataNotifikasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder<List<NotifikasiModel>>(
              future: _notifikasiData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<NotifikasiModel> notifikasiList = snapshot.data ?? [];
                  return Expanded(
                    child: ListView.builder(
                      itemCount: notifikasiList.length,
                      itemBuilder: (context, index) {
                        NotifikasiModel notifikasi = notifikasiList[index];
                        return Card(
                          child: ListTile(
                            title: Text(notifikasi.judul_notifikasi.toString()),
                            subtitle:
                                Text(notifikasi.pesan_notifikasi.toString()),
                            trailing: notifikasi.status_terbaca.toString() ==
                                    "0"
                                ? GestureDetector(
                                    onTap: () async {
                                      bool sudahBaca =
                                          await notifikasiController
                                              .updateNotifikasi(notifikasi
                                                  .id_notifikasi
                                                  .toString());
                                      if (sudahBaca) {
                                        setState(() {
                                          _notifikasiData = getDataNotifikasi();
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green,
                                      ),
                                      child: Text(
                                        "Sudah dibaca",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
