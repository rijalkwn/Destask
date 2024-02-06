import 'package:destask/controller/kategori_task_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/pekerjaan_controller.dart';
import '../../../controller/status_task_controller.dart';
import '../../../controller/task_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailTask extends StatefulWidget {
  const DetailTask({Key? key}) : super(key: key);

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  final String idtask = Get.parameters['idtask'] ?? '';
  TaskController taskController = TaskController();

  //kolom task
  String idTask = '';
  String idPekerjaan = '';
  String idUser = '';
  String idStatusTask = '';
  String idKategoriTask = '';
  DateTime tglPlaning = DateTime.now();
  String tglSelesai = '';
  String tglVerifikasiDiterima = '';
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

  getDataTask() async {
    var data = await taskController.getTaskById(idtask);
    setState(() {
      idTask = data[0].id_task ?? '-';
      idPekerjaan = data[0].id_pekerjaan ?? '-';
      idUser = data[0].id_user ?? '-';
      idStatusTask = data[0].id_status_task ?? '-';
      idKategoriTask = data[0].id_kategori_task ?? '-';
      tglPlaning = DateTime.parse(data[0].tgl_planing.toString());
      tglSelesai = data[0].tgl_selesai.toString() == 'null'
          ? '-'
          : data[0].tgl_selesai.toString();
      tglVerifikasiDiterima = data[0].tgl_verifikasi_diterima == null
          ? '-'
          : data[0].tgl_verifikasi_diterima.toString();
      statusVerifikasi = data[0].status_verifikasi ?? '-';
      persentaseSelesai = data[0].persentase_selesai ?? '-';
      deskripsiTask = data[0].deskripsi_task ?? '-';
      alasanVerifikasi = data[0].alasan_verifikasi ?? '-';
      buktiSelesai = data[0].bukti_selesai ?? '-';
      tautanTask = data[0].tautan_task ?? '-';
      namaUserTask = data[0].data_tambahan.nama_user ?? '-';
      namaPekerjaan = data[0].data_tambahan.nama_pekerjaan ?? '-';
      namaStatusTask = data[0].data_tambahan.nama_status_task ?? '-';
      namaKategoriTask = data[0].data_tambahan.nama_kategori_task ?? '-';
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
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Detail " + deskripsiTask,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Table(
                columnWidths: {
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
                  _buildTableRow('Deadline', tglPlaning),
                  _buildTableRow(
                      'Status Verifikasi',
                      statusVerifikasi == ''
                          ? 'Belum Diverifikasi'
                          : statusVerifikasi),
                  _buildTableRow('Persentase Selesai', persentaseSelesai + '%'),
                  _buildTableRowLink('Tautan Task', Uri.parse(tautanTask)),
                  _buildTableRow('Alasan Verifikasi',
                      alasanVerifikasi == '' ? '-' : alasanVerifikasi),
                  _buildTableRow(
                      'Tanggal Selesai', tglSelesai == '' ? '-' : tglSelesai),
                  _buildTableRow(
                      'Tanggal Verifikasi Diterima',
                      tglVerifikasiDiterima == ''
                          ? '-'
                          : tglVerifikasiDiterima),
                  _buildTableRow(
                      'Bukti Selesai', buktiSelesai == '' ? '-' : buktiSelesai),
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
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(":"),
          ),
        ),
        TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(value.toString()),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowLink(String label, Uri? link) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(":"),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: link != null
                ? RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: link.toString(),
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(link);
                            },
                        ),
                      ],
                    ),
                  )
                : Text('Tidak ada tautan'),
          ),
        ),
      ],
    );
  }
}
