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
  String desainer1 = '';
  String desainer2 = '';
  String beWeb1 = '';
  String beWeb2 = '';
  String beWeb3 = '';
  String beMobile1 = '';
  String beMobile2 = '';
  String beMobile3 = '';
  String feWeb1 = '';
  String feMobile1 = '';

  getDataPekerjaan() async {
    var data = await pekerjaanController.getPekerjaanById(idpekerjaan);
    setState(() {
      namaPekerjaan = data[0].nama_pekerjaan ?? '-';
      pelanggan = data[0].pelanggan ?? '-';
      jenisLayanan = data[0].jenis_layanan ?? '-';
      nominalHarga = data[0].nominal_harga ?? '-';
      deskripsiPekerjaan = data[0].deskripsi_pekerjaan ?? '-';
      targetWaktuSelesai = data[0].target_waktu_selesai.toString();
      persentaseSelesai = data[0].persentase_selesai ?? '-';
      waktuSelesai = data[0].waktu_selesai ?? '-';
      idPersonil = data[0].id_personil ?? '-';
      namaPM = data[0].data_tambahan.nama_pm ?? '-';
      desainer1 = data[0].data_tambahan.nama_desainer1 ?? '-';
      desainer2 = data[0].data_tambahan.nama_desainer2 ?? '-';
      beWeb1 = data[0].data_tambahan.nama_be_web1 ?? '-';
      beWeb2 = data[0].data_tambahan.nama_be_web2 ?? '-';
      beWeb3 = data[0].data_tambahan.nama_be_web3 ?? '-';
      beMobile1 = data[0].data_tambahan.nama_be_mobile1 ?? '-';
      beMobile2 = data[0].data_tambahan.nama_be_mobile2 ?? '-';
      beMobile3 = data[0].data_tambahan.nama_be_mobile3 ?? '-';
      feWeb1 = data[0].data_tambahan.nama_fe_web1 ?? '-';
      feMobile1 = data[0].data_tambahan.nama_fe_mobile1 ?? '-';
      namaStatus = data[0].data_tambahan.nama_status ?? '-';
      namaKategori = data[0].data_tambahan.nama_kategori ?? '-';
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
                  _buildTableRow('ID Personil', idPersonil),
                  _buildTableRowPersonil('- Project Manager', namaPM),
                  _buildTableRowPersonil('- Desainer 1', desainer1),
                  _buildTableRowPersonil('- Desainer 2', desainer2),
                  _buildTableRowPersonil('- Backend Web 1', beWeb1),
                  _buildTableRowPersonil('- Backend Web 2', beWeb2),
                  _buildTableRowPersonil('- Backend Web 3', beWeb3),
                  _buildTableRowPersonil('- Backend Mobile 1', beMobile1),
                  _buildTableRowPersonil('- Backend Mobile 2', beMobile2),
                  _buildTableRowPersonil('- Backend Mobile 3', beMobile3),
                  _buildTableRowPersonil('- Frontend Web 1', feWeb1),
                  _buildTableRowPersonil('- Frontend Mobile 1', feMobile1),
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
