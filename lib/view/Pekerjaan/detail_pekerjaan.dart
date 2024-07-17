import '../../controller/pekerjaan_controller.dart';
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
  UserController userController = UserController();

  // Kolom pekerjaan
  String idStatusPekerjaan = '';
  String idKategoriPekerjaan = '';
  String idPersonil = '';
  String namaPekerjaan = '-';
  String pelanggan = '-';
  String jenisPelanggan = '-';
  String namaPIC = '-';
  String emailPIC = '-';
  String noWaPIC = '-';
  String jenisLayanan = '-';
  String nominalHarga = '-';
  String deskripsiPekerjaan = '-';
  DateTime? targetWaktuSelesai;
  String persentaseSelesai = '-';
  DateTime? waktuSelesai;

  // Status
  String namaStatus = '-';

  // Kategori
  String namaKategori = '-';

  // Personil
  String namaPM = '-';
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
      targetWaktuSelesai = data[0].target_waktu_selesai;
      persentaseSelesai =
          data[0].data_tambahan.persentase_task_selesai?.toString() ?? '-';
      waktuSelesai = data[0].waktu_selesai;
      namaKategori = data[0].data_tambahan.nama_kategori_pekerjaan ?? '-';
      namaStatus = data[0].data_tambahan.nama_status_pekerjaan ?? '-';
      if (data[0].data_tambahan.project_manager.isNotEmpty) {
        namaPM = data[0].data_tambahan.project_manager[0].nama ?? '-';
      }
      desainerList = List<String>.from(
          data[0].data_tambahan.desainer.map((e) => e.nama).toList());
      backendWebList = List<String>.from(
          data[0].data_tambahan.backend_web.map((e) => e.nama).toList());
      backendMobileList = List<String>.from(
          data[0].data_tambahan.backend_mobile.map((e) => e.nama).toList());
      frontendWebList = List<String>.from(
          data[0].data_tambahan.frontend_web.map((e) => e.nama).toList());
      frontendMobileList = List<String>.from(
          data[0].data_tambahan.frontend_mobile.map((e) => e.nama).toList());
      testerList = List<String>.from(
          data[0].data_tambahan.tester.map((e) => e.nama).toList());
      adminList = List<String>.from(
          data[0].data_tambahan.admin.map((e) => e.nama).toList());
      helpdeskList = List<String>.from(
          data[0].data_tambahan.helpdesk.map((e) => e.nama).toList());
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
        title: const Text(
          "Detail Pekerjaan",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    namaPekerjaan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    pelanggan,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: GlobalColors.mainColor,
                      child: Text(
                        persentaseSelesai + '%',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detail('Deskripsi pekerjaan', deskripsiPekerjaan),
                    detail('Status pekerjaan', namaStatus),
                    detail('Kategori pekerjaan', namaKategori),
                    detail('Pelanggan', pelanggan),
                    detail('Jenis pelanggan', jenisPelanggan),
                    detail('PIC', namaPIC),
                    detail('Email PIC', emailPIC),
                    detail('No WA PIC', noWaPIC),
                    detail('Jenis layanan', jenisLayanan),
                    detail('Nominal harga', _formatRupiah(nominalHarga)),
                    detail(
                        'Target waktu selesai', formatDate(targetWaktuSelesai)),
                    detail('Waktu selesai', formatDate(waktuSelesai)),
                    personilDetail(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container detail(String judul, String isi) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isi,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget personilDetail() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personil',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(7),
              1: FlexColumnWidth(0.5),
              2: FlexColumnWidth(10),
            },
            children: [
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
          )
        ],
      ),
    );
  }

  TableRow _buildTableRowPersonil(String role, String names) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            role,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const Text(':'),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            names,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    try {
      return DateFormat('dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return '-';
    }
  }

  String _formatRupiah(String nominal) {
    if (nominal.isEmpty || nominal == '-') return '-';
    try {
      final value = int.parse(nominal);
      final formattedValue = NumberFormat.currency(
              locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0)
          .format(value);
      return formattedValue;
    } catch (e) {
      return '-';
    }
  }
}
