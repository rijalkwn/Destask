import 'package:destask/controller/pekerjaan_controller.dart';
import 'package:destask/view/Pekerjaan/pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailPekerjaan extends StatefulWidget {
  const DetailPekerjaan({Key? key}) : super(key: key);

  @override
  State<DetailPekerjaan> createState() => _DetailPekerjaanState();
}

class _DetailPekerjaanState extends State<DetailPekerjaan> {
  String idPekerjaan = '';
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

  void detailPekerjaan() async {
    try {
      final String idpekerjaan = Get.parameters['idpekerjaan'] ?? '';
      PekerjaanController pekerjaanController = PekerjaanController();
      Map<String, dynamic> pekerjaan =
          await pekerjaanController.getPekerjaanById(idpekerjaan);
      setState(() {
        idPekerjaan = pekerjaan['id_pekerjaan'] ?? '';
        idStatusPekerjaan = pekerjaan['id_status_pekerjaan'] ?? '';
        idKategoriPekerjaan = pekerjaan['id_kategori_pekerjaan'] ?? '';
        idPersonil = pekerjaan['id_personil'] ?? '';
        namaPekerjaan = pekerjaan['nama_pekerjaan'] ?? '';
        pelanggan = pekerjaan['pelanggan'] ?? '';
        jenisLayanan = pekerjaan['jenis_layanan'] ?? '';
        nominalHarga = pekerjaan['nominal_harga'] ?? '';
        deskripsiPekerjaan = pekerjaan['deskripsi_pekerjaan'] ?? '';
        targetWaktuSelesai = pekerjaan['target_waktu_selesai'] ?? '';
        persentaseSelesai = pekerjaan['persentase_selesai'] ?? '';
        waktuSelesai = pekerjaan['waktu_selesai'] ?? '';
      });
    } catch (e) {
      print('Error detail pekerjaan: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailPekerjaan();
  }

  // ... (kode sebelumnya)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(namaPekerjaan ?? ''),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
          },
          children: [
            _buildTableRow('ID Pekerjaan', idPekerjaan),
            _buildTableRow('ID Status Pekerjaan', idStatusPekerjaan),
            _buildTableRow('ID Kategori Pekerjaan', idKategoriPekerjaan),
            _buildTableRow('ID Personil', idPersonil),
            _buildTableRow('Nama Pekerjaan', namaPekerjaan),
            _buildTableRow('Pelanggan', pelanggan),
            _buildTableRow('Jenis Layanan', jenisLayanan),
            _buildTableRow('Nominal Harga', _formatRupiah(nominalHarga)),
            _buildTableRow('Deskripsi Pekerjaan', deskripsiPekerjaan),
            _buildTableRow(
                'Target Waktu Selesai', _formatDatetime(targetWaktuSelesai)),
            _buildTableRow('Persentase Selesai', persentaseSelesai),
            _buildTableRow('Waktu Selesai', _formatDatetime(waktuSelesai)),
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
}
