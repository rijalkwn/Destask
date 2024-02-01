import 'package:destask/model/kategori_pekerjaan_model.dart';

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

  //status
  String namaStatus = '';

  //kategori
  String namaKategori = '';

  //bantuan
  String idpersonil = '';
  String idstatus = '';
  String idkategori = '';

  //personil
  String idUserPM = '';
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

  //user
  String namaIdUserPM = '';
  String namaDesigner1 = '';
  String namaDesigner2 = '';
  String namaBEWeb1 = '';
  String namaBEWeb2 = '';
  String namaBEWeb3 = '';
  String namaBEMobile1 = '';
  String namaBEMobile2 = '';
  String namaBEMobile3 = '';
  String namaFEWeb1 = '';
  String namaFEMobile1 = '';

  getDataPekerjaan() async {
    var data = await pekerjaanController.getPekerjaanById(idpekerjaan);
    setState(() {
      idPekerjaan = data[0].id_pekerjaan ?? '';
      idStatusPekerjaan = data[0].id_status_pekerjaan ?? '';
      idKategoriPekerjaan = data[0].id_kategori_pekerjaan ?? '';
      idPersonil = data[0].id_personil ?? '';
      namaPekerjaan = data[0].nama_pekerjaan ?? '';
      pelanggan = data[0].pelanggan ?? '';
      jenisLayanan = data[0].jenis_layanan ?? '';
      nominalHarga = data[0].nominal_harga ?? '';
      deskripsiPekerjaan = data[0].deskripsi_pekerjaan ?? '';
      targetWaktuSelesai = data[0].target_waktu_selesai ?? '';
      persentaseSelesai = data[0].persentase_selesai ?? '';
      waktuSelesai = data[0].waktu_selesai ?? '';
    });
    return data;
  }

  //get data status
  getDataStatus() async {
    var data = await statusPekerjaanController.getStatusById(idstatus);
    setState(() {
      namaStatus = data[0].nama_status_pekerjaan ?? '';
    });
    return data;
  }

  //getdata kategori
  getDataKategori() async {
    var data =
        await kategoriPekerjaanController.getKategoriPekerjaanById(idkategori);
    setState(() {
      namaKategori = data[0].nama_kategori_pekerjaan ?? '';
    });
    return data;
  }

  getDataPersonil() async {
    var data = await personilController.getPersonilById(idpersonil);
    setState(() {
      idUserPM = data[0].id_user_pm ?? '';
      desainer1 = data[0].desainer1 ?? '';
      desainer2 = data[0].desainer2 ?? '';
      beWeb1 = data[0].be_web1 ?? '';
      beWeb2 = data[0].be_web2 ?? '';
      beWeb3 = data[0].be_web3 ?? '';
      beMobile1 = data[0].be_mobile1 ?? '';
      beMobile2 = data[0].be_mobile2 ?? '';
      beMobile3 = data[0].be_mobile3 ?? '';
      feWeb1 = data[0].fe_web1 ?? '';
      feMobile1 = data[0].fe_mobile1 ?? '';
    });
    return data;
  }

  getDataUser() async {
    var data = await userController.getAllUser();
    setState(() {
      //cek apakah idUserPM = id user
      for (var i = 0; i < data.length; i++) {
        if (idUserPM == data[i].id_user.toString()) {
          namaIdUserPM = data[i].nama.toString();
        }
        if (desainer1 == data[i].id_user) {
          namaDesigner1 = data[i].nama ?? '';
        }
        if (desainer2 == data[i].id_user) {
          namaDesigner2 = data[i].nama ?? '';
        }
        if (beWeb1 == data[i].id_user) {
          namaBEWeb1 = data[i].nama ?? '';
        }
        if (beWeb2 == data[i].id_user) {
          namaBEWeb2 = data[i].nama ?? '';
        }
        if (beWeb3 == data[i].id_user) {
          namaBEWeb3 = data[i].nama ?? '';
        }
        if (beMobile1 == data[i].id_user) {
          namaBEMobile1 = data[i].nama ?? '';
        }
        if (beMobile2 == data[i].id_user) {
          namaBEMobile2 = data[i].nama ?? '';
        }
        if (beMobile3 == data[i].id_user) {
          namaBEMobile3 = data[i].nama ?? '';
        }
        if (feWeb1 == data[i].id_user) {
          namaFEWeb1 = data[i].nama ?? '';
        }
        if (feMobile1 == data[i].id_user) {
          namaFEMobile1 = data[i].nama ?? '';
        }
      }
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    getDataPekerjaan().then((value) {
      setState(() {
        idpersonil = value[0].id_personil.toString();
        idstatus = value[0].id_status_pekerjaan.toString();
        idkategori = value[0].id_kategori_pekerjaan.toString();
      });
      getDataStatus();
      getDataKategori();
      getDataPersonil().then((value) {
        getDataUser();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(namaStatus);
    print(idKategoriPekerjaan);
    print(namaKategori);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Detail " + namaPekerjaan,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      namaPekerjaan,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      namaStatus,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        persentaseSelesai + '%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(7),
                  1: FlexColumnWidth(0.5),
                  2: FlexColumnWidth(10),
                },
                children: [
                  _buildTableRow('ID Pekerjaan', idPekerjaan),
                  _buildTableRow('Pelanggan', pelanggan),
                  _buildTableRow('Kategori Pekerjaan', namaKategori),
                  _buildTableRow('Jenis Layanan', jenisLayanan),
                  _buildTableRow('Nominal Harga', _formatRupiah(nominalHarga)),
                  _buildTableRow('Deskripsi Pekerjaan', deskripsiPekerjaan),
                  _buildTableRow('Target Waktu Selesai',
                      _formatDatetime(targetWaktuSelesai)),
                  _buildTableRow(
                      'Waktu Selesai', _formatDatetime(waktuSelesai)),
                  //personil
                  _buildTableRow('ID Personil', idPersonil),
                  _buildTableRowPersonil('- Project Manager', namaIdUserPM),
                  _buildTableRowPersonil('- Desainer 1', namaDesigner1),
                  _buildTableRowPersonil('- Desainer 2', namaDesigner2),
                  _buildTableRowPersonil('- Back End Web 1', namaBEWeb1),
                  _buildTableRowPersonil('- Back End Web 2', namaBEWeb2),
                  _buildTableRowPersonil('- Back End Web 3', namaBEWeb3),
                  _buildTableRowPersonil('- Back End Mobile 1', namaBEMobile1),
                  _buildTableRowPersonil('- Back End Mobile 2', namaBEMobile2),
                  _buildTableRowPersonil('- Back End Mobile 3', namaBEMobile3),
                  _buildTableRowPersonil('- Front End Web 1', namaFEWeb1),
                  _buildTableRowPersonil('- Front End Mobile 1', namaFEMobile1),
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
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 3),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.normal),
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
