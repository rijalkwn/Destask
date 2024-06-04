import '../../controller/kategori_pekerjaan_controller.dart';
import '../../controller/pekerjaan_controller.dart';
import '../../controller/personil_controller.dart';
import '../../controller/status_pekerjaan_controller.dart';
import '../../controller/user_controller.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailPekerjaan extends StatefulWidget {
  const DetailPekerjaan({Key? key}) : super(key: key);

  @override
  State<DetailPekerjaan> createState() => _DetailPekerjaanState();
}

class _DetailPekerjaanState extends State<DetailPekerjaan> {
  final String idpekerjaan = Get.parameters['idpekerjaan'] ?? '';
  PekerjaanController pekerjaanController = PekerjaanController();
  StatusPekerjaanController statusPekerjaanController =
      StatusPekerjaanController();
  KategoriPekerjaanController kategoriPekerjaanController =
      KategoriPekerjaanController();
  PersonilController personilController = PersonilController();
  UserController userController = UserController();

  //kolom pekerjaan
  String idStatusPekerjaan = '';
  String idKategoriPekerjaan = '';
  String idPersonil = '';
  String namaPekerjaan = '';
  String pelanggan = '';
  String jenisPelanggan = '';
  String namaPIC = '';
  String emailPIC = '';
  String noWaPIC = '';
  String jenisLayanan = '';
  String nominalHarga = '';
  String deskripsiPekerjaan = '';
  String targetWaktuSelesai = '';
  String persentaseSelesai = '';
  String waktuSelesai = '';

  //status
  String namaStatus = '';

  //kategori
  String namaKategori = '';

  //personil
  String namaPM = '';
  List<String> desainerList = [];
  List<String> backendWebList = [];
  List<String> backendMobileList = [];
  List<String> frontendWebList = [];
  List<String> frontendMobileList = [];
  List<String> testerList = [];
  List<String> adminList = [];
  List<String> helpdeskList = [];

  getDataPekerjaan() async {
    var data = await pekerjaanController.getPekerjaanById(idpekerjaan);
    setState(() {
      namaPekerjaan = data[0].nama_pekerjaan ?? '-';
      pelanggan = data[0].pelanggan ?? '-';
      jenisPelanggan = data[0].jenis_pelanggan ?? '-';
      namaPIC = data[0].nama_pic ?? '-';
      emailPIC = data[0].email_pic ?? '-';
      noWaPIC = data[0].nowa_pic ?? '-';
      jenisLayanan = data[0].jenis_layanan ?? '-';
      nominalHarga = data[0].nominal_harga ?? '-';
      deskripsiPekerjaan = data[0].deskripsi_pekerjaan ?? '-';
      targetWaktuSelesai = data[0].target_waktu_selesai.toString();
      persentaseSelesai = data[0].persentase_selesai ?? '-';
      waktuSelesai = data[0].waktu_selesai != null
          ? data[0].waktu_selesai.toString()
          : '-';
      namaKategori = data[0].data_tambahan.nama_kategori_pekerjaan ?? '-';
      namaStatus = data[0].data_tambahan.nama_status_pekerjaan ?? '-';
      if (data[0].data_tambahan.pm.isNotEmpty) {
        namaPM = data[0].data_tambahan.pm[0].nama;
      }
      if (data[0].data_tambahan.desainer.isNotEmpty) {
        desainerList = List<String>.from(
            data[0].data_tambahan.desainer.map((e) => e.nama).toList());
      }
      if (data[0].data_tambahan.backend_web.isNotEmpty) {
        backendWebList = List<String>.from(
            data[0].data_tambahan.backend_web.map((e) => e.nama).toList());
      }
      if (data[0].data_tambahan.backend_mobile.isNotEmpty) {
        backendMobileList = List<String>.from(
            data[0].data_tambahan.backend_mobile.map((e) => e.nama).toList());
      }
      if (data[0].data_tambahan.frontend_web.isNotEmpty) {
        frontendWebList = List<String>.from(
            data[0].data_tambahan.frontend_web.map((e) => e.nama).toList());
      }
      if (data[0].data_tambahan.frontend_mobile.isNotEmpty) {
        frontendMobileList = List<String>.from(
            data[0].data_tambahan.frontend_mobile.map((e) => e.nama).toList());
      }
      //tester
      if (data[0].data_tambahan.tester.isNotEmpty) {
        testerList = List<String>.from(
            data[0].data_tambahan.tester.map((e) => e.nama).toList());
      }
      //admin
      if (data[0].data_tambahan.admin.isNotEmpty) {
        adminList = List<String>.from(
            data[0].data_tambahan.admin.map((e) => e.nama).toList());
      }
      //helpdesk
      if (data[0].data_tambahan.helpdesk.isNotEmpty) {
        helpdeskList = List<String>.from(
            data[0].data_tambahan.helpdesk.map((e) => e.nama).toList());
      }
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    getDataPekerjaan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Detail $namaPekerjaan",
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      namaPekerjaan,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      namaStatus,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$persentaseSelesai%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(7),
                  1: FlexColumnWidth(0.5),
                  2: FlexColumnWidth(10),
                },
                children: [
                  _buildTableRow('ID Pekerjaan', idpekerjaan),
                  _buildTableRow('Pelanggan', pelanggan),
                  _buildTableRow('Jenis Pelanggan', jenisPelanggan),
                  _buildTableRow('Nama PIC', namaPIC),
                  _buildTableRow('Email PIC', emailPIC),
                  _buildTableRow('No. WA PIC', noWaPIC),
                  _buildTableRow('Kategori Pekerjaan', namaKategori),
                  _buildTableRow('Jenis Layanan', jenisLayanan),
                  _buildTableRow('Nominal Harga', _formatRupiah(nominalHarga)),
                  _buildTableRow('Deskripsi Pekerjaan', deskripsiPekerjaan),
                  _buildTableRow(
                      'Target Waktu Selesai',
                      targetWaktuSelesai == ''
                          ? '-'
                          : formatDate(targetWaktuSelesai)),
                  _buildTableRow('Waktu Selesai',
                      waktuSelesai == '' ? '-' : formatDate(waktuSelesai)),
                  //personil
                  _buildTableRow('Personil', ''),
                  _buildTableRowPersonil('- Project Manager', namaPM),
                  _buildTableRowPersonil('- Desainer', desainerList.join('\n')),
                  _buildTableRowPersonil(
                      '- Backend Web', backendWebList.join('\n')),
                  _buildTableRowPersonil(
                      '- Backend Mobile', backendMobileList.join('\n')),
                  _buildTableRowPersonil(
                      '- Frontend Web', frontendWebList.join('\n')),
                  _buildTableRowPersonil(
                      '- Frontend Mobile', frontendMobileList.join('\n')),
                  _buildTableRowPersonil('- Tester', testerList.join('\n')),
                  _buildTableRowPersonil('- Admin', adminList.join('\n')),
                  _buildTableRowPersonil('- Helpdesk', helpdeskList.join('\n')),
                ],
              ),
            ),
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
            child: Text(value == null ? '-' : value.toString()),
          ),
        ),
      ],
    );
  }

  //khusus personil
  TableRow _buildTableRowPersonil(String label, dynamic value) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.normal),
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

  String _formatRupiah(String amount) {
    try {
      int nominal = int.parse(amount);
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
      ).format(nominal);
    } catch (e) {
      print('Error parsing amount: $e');
      return amount;
    }
  }

  //ubah format tanggal
  String formatDate(String date) {
    if (date == '-') {
      return '-';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'id').format(dateTime);
  }
}
