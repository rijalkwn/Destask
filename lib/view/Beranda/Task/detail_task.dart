import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/controller/task_controller.dart';
import 'package:destask/view/Pekerjaan/pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailTask extends StatefulWidget {
  const DetailTask({Key? key}) : super(key: key);

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  String idTask = '';
  String idPekerjaan = '';
  String idUser = '';
  String idStatusTask = '';
  String idKategoriTask = '';
  String tglPlaning = '';
  String tglSelesai = '';
  String tglVerifikasiDiterima = '';
  String statusVerifikasi = '';
  String persentaseSelesai = '';
  String deskripsiTask = '';
  String alasanVerifikasi = '';
  String buktiSelesai = '';
  String tautanTask = '';

  detailTask() async {
    try {
      final String idtask = Get.parameters['idtask'] ?? '';
      TaskController taskController = TaskController();
      Map<String, dynamic> task = await taskController.getTaskById(idtask);
      setState(() {
        idTask = task['id_task'] ?? '';
        idPekerjaan = task['id_pekerjaan'] ?? '';
        idUser = task['id_user'] ?? '';
        idStatusTask = task['id_status_task'] ?? '';
        idKategoriTask = task['id_kategori_task'] ?? '';
        tglPlaning = task['tgl_planing'] ?? '';
        tglSelesai = task['tgl_selesai'] ?? '';
        tglVerifikasiDiterima = task['tgl_verifikasi_diterima'] ?? '';
        statusVerifikasi = task['status_verifikasi'] ?? '';
        persentaseSelesai = task['persentase_selesai'] ?? '';
        deskripsiTask = task['deskripsi_task'] ?? '';
        alasanVerifikasi = task['alasan_verifikasi'] ?? '';
        buktiSelesai = task['bukti_selesai'] ?? '';
        tautanTask = task['tautan_task'] ?? '';
      });
    } catch (e) {
      print('Error detail pekerjaan: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailTask();
  }

  // ... (kode sebelumnya)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deskripsiTask ?? ''),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
          },
          children: [
            _buildTableRow('ID Task', idTask),
            _buildTableRow('ID Pekerjaan', idPekerjaan),
            _buildTableRow('ID User', idUser),
            _buildTableRow('ID Status Task', idStatusTask),
            _buildTableRow('ID Kategori Task', idKategoriTask),
            _buildTableRow('Tanggal Planing', _formatDatetime(tglPlaning)),
            _buildTableRow('Tanggal Selesai', _formatDatetime(tglSelesai)),
            _buildTableRow('Tanggal Verifikasi Diterima',
                _formatDatetime(tglVerifikasiDiterima)),
            _buildTableRow('Status Verifikasi', statusVerifikasi),
            _buildTableRow('Persentase Selesai', persentaseSelesai),
            _buildTableRow('Deskripsi Task', deskripsiTask),
            _buildTableRow('Alasan Verifikasi', alasanVerifikasi),
            _buildTableRow('Bukti Selesai', buktiSelesai),
            _buildTableRow('Tautan Task', tautanTask),
          ],
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
            child: Text(value.toString()),
          ),
        ),
      ],
    );
  }

  String _formatDatetime(String datetimeString) {
    try {
      DateTime datetime = DateTime.parse(datetimeString);
      String formattedDate = DateFormat('d MMMM y', 'id_ID').format(datetime);
      return formattedDate;
    } catch (e) {
      print('Error parsing date: $e');
      return datetimeString;
    }
  }
}
