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
  UserController userController = UserController();
  PekerjaanController pekerjaanController = PekerjaanController();
  StatusTaskController statusTaskController = StatusTaskController();

  //kolom task
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

  //bantuan
  String namaUserTask = '';
  String namaPekerjaan = '';
  String namaStatusTask = '';

  getDataTask() async {
    var data = await taskController.getTaskById(idtask);
    setState(() {
      idTask = data[0].id_task ?? '';
      idPekerjaan = data[0].id_pekerjaan ?? '';
      idUser = data[0].id_user ?? '';
      idStatusTask = data[0].id_status_task ?? '';
      idKategoriTask = data[0].id_kategori_task ?? '';
      tglPlaning = data[0].tgl_planing ?? '';
      tglSelesai = data[0].tgl_selesai ?? '';
      tglVerifikasiDiterima = data[0].tgl_verifikasi_diterima ?? '';
      statusVerifikasi = data[0].status_verifikasi ?? '';
      persentaseSelesai = data[0].persentase_selesai ?? '';
      deskripsiTask = data[0].deskripsi_task ?? '';
      alasanVerifikasi = data[0].alasan_verifikasi ?? '';
      buktiSelesai = data[0].bukti_selesai ?? '';
      tautanTask = data[0].tautan_task ?? '';
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    getDataTask().then((value) {
      setState(() {
        idUser = value[0].id_user.toString();
        idPekerjaan = value[0].id_pekerjaan.toString();
        idStatusTask = value[0].id_status_task.toString();
      });
      getDataUser();
      getDataPekerjaan();
      getDataStatusTask();
    });
  }

  getDataUser() async {
    var data = await userController.getAllUser();
    setState(() {
      for (var i = 0; i < data.length; i++) {
        if (data[i].id_user == idUser) {
          namaUserTask = data[i].nama ?? '';
        }
      }
    });
    return data;
  }

  getDataPekerjaan() async {
    var data = await pekerjaanController.getPekerjaanById(idPekerjaan);
    setState(() {
      namaPekerjaan = data[0].nama_pekerjaan ?? '';
    });
    return data;
  }

  getDataStatusTask() async {
    var data = await statusTaskController.getStatusById(idStatusTask);
    setState(() {
      namaStatusTask = data[0].nama_status_task ?? '';
    });
    return data;
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
                  _buildTableRow('ID Kategori Task', idKategoriTask),
                  _buildTableRow('Tanggal Planing', tglPlaning),
                  _buildTableRow('Status Verifikasi', statusVerifikasi),
                  _buildTableRow('Persentase Selesai', persentaseSelesai),
                  _buildTableRow('Tautan Task', tautanTask),
                  _buildTableRow('Alasan Verifikasi', alasanVerifikasi),
                  _buildTableRow('Tanggal Selesai', tglSelesai),
                  _buildTableRow(
                      'Tanggal Verifikasi Diterima', tglVerifikasiDiterima),
                  _buildTableRow('Bukti Selesai', buktiSelesai),
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

  String _formatDatetime(String datetimeString) {
    try {
      // Misalnya, jika format yang diberikan adalah 'yyyy-MM-dd'
      DateTime datetime = DateFormat('yyyy-MM-dd').parse(datetimeString);

      // Kemudian, konversi ke format yang diinginkan, misalnya 'd MMMM y'
      String formattedDate = DateFormat('d MMMM y', 'id_ID').format(datetime);

      return formattedDate;
    } catch (e) {
      print('Error parsing date: $e');
      return datetimeString;
    }
  }
}
