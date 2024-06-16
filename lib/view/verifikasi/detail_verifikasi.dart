import 'package:destask/utils/constant_api.dart';
import 'package:destask/view/Beranda/Task/my_date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../../../controller/task_controller.dart';
import '../../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailVerifikasi extends StatefulWidget {
  const DetailVerifikasi({Key? key}) : super(key: key);

  @override
  State<DetailVerifikasi> createState() => _DetailVerifikasiState();
}

class _DetailVerifikasiState extends State<DetailVerifikasi> {
  var url = '$baseURL/assets/bukti_task/';
  final String idtask = Get.parameters['idtask'] ?? '';
  TaskController taskController = TaskController();

  //kolom task
  String idTask = '';
  String idPekerjaan = '';
  String idUser = '';
  String idStatusTask = '';
  String idKategoriTask = '';
  DateTime tglPlaning = DateTime.now();
  DateTime tglSelesai = DateTime.now();
  DateTime tglVerifikasiDiterima = DateTime.now();
  String statusVerifikasi = '';
  String persentaseSelesai = '';
  String deskripsiTask = '';
  String alasanVerifikasi = '';
  String buktiSelesai = '';
  String tautanTask = '';

  //bantuan
  String namaUserTask = '';
  String namaPekerjaan = '';
  String namaStatusTask = '';
  String namaKategoriTask = '';

  bool isLoading = false;
  String status = '';

  getDataTask() async {
    print(idtask);
    var data = await taskController.getTaskById(idtask);
    setState(() {
      idTask = data[0].id_task ?? '-';
      idPekerjaan = data[0].id_pekerjaan ?? '-';
      idUser = data[0].id_user ?? '-';
      idStatusTask = data[0].id_status_task ?? '-';
      idKategoriTask = data[0].id_kategori_task ?? '-';
      tglPlaning = DateTime.parse(data[0].tgl_planing.toString());
      persentaseSelesai = data[0].persentase_selesai ?? '-';
      deskripsiTask = data[0].deskripsi_task ?? '-';
      buktiSelesai = data[0].bukti_selesai ?? '-';
      tautanTask = data[0].tautan_task ?? '-';
      namaUserTask = data[0].data_tambahan.nama_user;
      namaPekerjaan = data[0].data_tambahan.nama_pekerjaan;
      namaStatusTask = data[0].data_tambahan.nama_status_task;
      namaKategoriTask = data[0].data_tambahan.nama_kategori_task;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    getDataTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Detail $deskripsiTask",
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(7),
                  1: FlexColumnWidth(0.5),
                  2: FlexColumnWidth(10),
                },
                children: [
                  _buildTableRow('ID Task', idTask),
                  _buildTableRow('Pekerjaan', namaPekerjaan),
                  _buildTableRow('User', namaUserTask),
                  _buildTableRow('Deskripsi Task', deskripsiTask),
                  _buildTableRow('Status Task', namaStatusTask),
                  _buildTableRow('Kategori Task', namaKategoriTask),
                  _buildTableRow(
                      'Deadline',
                      DateFormat('dd MMMM yyyy')
                          .format(DateTime.parse(tglPlaning.toString()))),
                  _buildTableRow('Persentase Selesai', '$persentaseSelesai%'),
                  _buildTableRowLink('Tautan Task', tautanTask),
                  _buildBuktiSelesai('Bukti Selesai', buktiSelesai),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        //menampilkan dialog isinya form alasan verifikasi
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String alasanVerifikasiLocal = '';
                            return AlertDialog(
                              title: const Text('Tolak Task Ini?'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Alasan menolak (wajib)'),
                                      TextField(
                                        onChanged: (value) {
                                          alasanVerifikasiLocal = value;
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (alasanVerifikasiLocal.isEmpty) {
                                      QuickAlert.show(
                                        context: context,
                                        title: "Alasan tidak boleh kosong",
                                        type: QuickAlertType.warning,
                                      );
                                      return;
                                    }
                                    Navigator.pop(context);
                                    setState(() {
                                      isLoading = true;
                                      status = "4"; //status ditolak
                                    });
                                    bool success = await taskController
                                        .editTaskVerikasiTolak(
                                            idTask,
                                            alasanVerifikasiLocal,
                                            tglPlaning,
                                            status);

                                    // Jika verifikasi task berhasil, Anda dapat menambahkan logika penanganan berhasil di sini
                                    if (success) {
                                      Get.offAndToNamed(
                                          '/verifikasi_task/$idPekerjaan');
                                      QuickAlert.show(
                                        context: context,
                                        title: "Berhasil Menolak Task",
                                        type: QuickAlertType.success,
                                      );
                                    } else {
                                      Navigator.pop(context);
                                      QuickAlert.show(
                                        context: context,
                                        title: "Gagal Menolak Task",
                                        type: QuickAlertType.error,
                                      );
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Tolak'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Center(
                          child: Text(
                            'Tolak',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  //terima verifikasi
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          alasanVerifikasi = '-';
                        });
                        //menampilkan dialog yakin menerima verifikasi
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Yakin Terima Task Ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(
                                        context); // Close the dialog immediately

                                    setState(() {
                                      isLoading = true;
                                      status = "3"; //status selesai
                                    });

                                    // Perform the asynchronous operation
                                    bool success = await taskController
                                        .editTaskVerikasiDiterima(
                                            idTask,
                                            alasanVerifikasi,
                                            tglPlaning,
                                            status);

                                    // Handle the result of the asynchronous operation
                                    if (success) {
                                      Get.offAndToNamed(
                                          '/verifikasi_task/$idPekerjaan');
                                      QuickAlert.show(
                                        context: context,
                                        title: "Berhasil Memverifikasi Task",
                                        type: QuickAlertType.success,
                                      );
                                    } else {
                                      QuickAlert.show(
                                        context: context,
                                        title: "Gagal Memverifikasi Task",
                                        type: QuickAlertType.error,
                                      );
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: const Text('Terima'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: GlobalColors.mainColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Center(
                          child: Text(
                            'Terima',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, dynamic value) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(":"),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(value.toString()),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowLink(String label, String link) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(":"),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    link.isNotEmpty
                        ? link.length > 30
                            ? '${link.substring(0, 30)}...'
                            : link
                        : "Tidak ada tautan",
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    if (link.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: link));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tautan berhasil disalin!'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildBuktiSelesai(String label, String namafoto) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(":"),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text('Tidak ada bukti selesai'),
                // cek apakah ada bukti selesai
                namafoto == ''
                    ? const Text('Tidak ada bukti selesai')
                    : GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage('$url/$namafoto'),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Image.network(
                          '$url/$namafoto',
                          width: 100,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
