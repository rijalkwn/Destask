import 'package:destask/utils/constant_api.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../controller/task_controller.dart';
import '../../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailTask extends StatefulWidget {
  const DetailTask({Key? key}) : super(key: key);

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  var url = '$baseURL/assets/bukti_task/';
  final String idtask = Get.parameters['idtask'] ?? '';
  TaskController taskController = TaskController();

  //kolom task
  String idTask = '';
  String idPekerjaan = '';
  String idUser = '';
  String creator = '';
  String idStatusTask = '';
  String idKategoriTask = '';
  DateTime tglPlaning = DateTime.now();
  String tglSelesai = '';
  String tglVerifikasiDiterima = '';
  String persentaseSelesai = '';
  String deskripsiTask = '';
  String alasanVerifikasi = '';
  String buktiSelesai = '';
  String tautanTask = '';
  String statusVerifikasi = '';

  //bantuan
  String namaCreator = '';
  String namaUserTask = '';
  String namaPekerjaan = '';
  String namaStatusTask = '';
  String namaKategoriTask = '';

  getDataTask() async {
    var data = await taskController.getTaskById(idtask);
    setState(() {
      idTask = data[0].id_task ?? '-';
      idPekerjaan = data[0].id_pekerjaan ?? '-';
      idUser = data[0].id_user ?? '-';
      creator = data[0].creator ?? '-';
      idStatusTask = data[0].id_status_task ?? '-';
      idKategoriTask = data[0].id_kategori_task ?? '-';
      tglPlaning = DateTime.parse(data[0].tgl_planing.toString());
      tglSelesai = data[0].tgl_selesai.toString() == 'null'
          ? '-'
          : data[0].tgl_selesai.toString();
      tglVerifikasiDiterima = data[0].tgl_verifikasi_diterima == null
          ? '-'
          : data[0].tgl_verifikasi_diterima.toString();
      persentaseSelesai = data[0].persentase_selesai ?? '-';
      deskripsiTask = data[0].deskripsi_task ?? '-';
      alasanVerifikasi = data[0].alasan_verifikasi ?? '-';
      buktiSelesai = data[0].bukti_selesai ?? '';
      tautanTask = data[0].tautan_task ?? '-';
      namaUserTask = data[0].data_tambahan.nama_user;
      namaCreator = data[0].data_tambahan.nama_creator;
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
                  _buildTableRow('Creator', namaCreator),
                  _buildTableRow('Deskripsi Task', deskripsiTask),
                  _buildTableRow('Status Task', namaStatusTask),
                  _buildTableRow('Kategori Task', namaKategoriTask),
                  _buildTableRow('Deadline', formatDate(tglPlaning.toString())),
                  _buildTableRow('Persentase Selesai', '$persentaseSelesai%'),
                  _buildTableRowLink('Tautan Task', tautanTask),
                  _buildTableRow('Alasan Verifikasi',
                      alasanVerifikasi == '' ? '-' : alasanVerifikasi),
                  _buildTableRow(
                      'Tanggal Selesai', tglSelesai == '' ? '-' : tglSelesai),
                  _buildTableRow(
                      'Tanggal Verifikasi Diterima',
                      tglVerifikasiDiterima == ''
                          ? '-'
                          : tglVerifikasiDiterima),
                  _buildBuktiSelesai('Bukti Selesai', buktiSelesai),
                ],
              ),
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                //cek apakah ada bukti selesai
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
                          height: 100,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //format tanggal
  String formatDate(String date) {
    if (date == '-') {
      return '-';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'id').format(dateTime);
  }
}
