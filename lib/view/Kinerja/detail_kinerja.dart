import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:destask/controller/kinerja_controller.dart';
import 'package:destask/utils/global_colors.dart';

class DetailKinerja extends StatefulWidget {
  const DetailKinerja({Key? key}) : super(key: key);

  @override
  State<DetailKinerja> createState() => _DetailKinerjaState();
}

class _DetailKinerjaState extends State<DetailKinerja> {
  final String idKinerja = Get.parameters['idkinerja'] ?? '';
  KinerjaController kinerjaController = KinerjaController();

  // Data
  String id_kinerja = '';
  String id_user = '';
  String tahun = '';
  String bulan = '';
  String jumlah_kehadiran = '';
  String jumlah_izin = '';
  String jumlah_sakit_tnp_ket_dokter = '';
  String jumlah_mangkir = '';
  String jumlah_terlambat = '';
  String kebersihan_diri = '';
  String kerapihan_penampilan = '';
  String integritas_a = '';
  String integritas_b = '';
  String integritas_c = '';
  String kerjasama_a = '';
  String kerjasama_b = '';
  String kerjasama_c = '';
  String kerjasama_d = '';
  String orientasi_thd_konsumen_a = '';
  String orientasi_thd_konsumen_b = '';
  String orientasi_thd_konsumen_c = '';
  String orientasi_thd_konsumen_d = '';
  String orientasi_thd_target_a = '';
  String orientasi_thd_target_b = '';
  String orientasi_thd_target_c = '';
  String orientasi_thd_target_d = '';
  String inisiatif_inovasi_a = '';
  String inisiatif_inovasi_b = '';
  String inisiatif_inovasi_c = '';
  String inisiatif_inovasi_d = '';
  String professionalisme_a = '';
  String professionalisme_b = '';
  String professionalisme_c = '';
  String professionalisme_d = '';
  String organizational_awareness_a = '';
  String organizational_awareness_b = '';
  String organizational_awareness_c = '';
  String score_kpi = '';

  @override
  void initState() {
    super.initState();
    getDataKinerja();
  }

  getDataKinerja() async {
    print('ini id kinerja $idKinerja');
    var data = await kinerjaController.getKinerjaById(idKinerja);
    setState(() {
      id_kinerja = data[0].id_kinerja;
      id_user = data[0].id_user;
      tahun = data[0].tahun;
      bulan = data[0].bulan;
      jumlah_kehadiran = data[0].jumlah_kehadiran;
      jumlah_izin = data[0].jumlah_izin;
      jumlah_sakit_tnp_ket_dokter = data[0].jumlah_sakit_tnp_ket_dokter;
      jumlah_mangkir = data[0].jumlah_mangkir;
      jumlah_terlambat = data[0].jumlah_terlambat;
      kebersihan_diri = data[0].kebersihan_diri;
      kerapihan_penampilan = data[0].kerapihan_penampilan;
      integritas_a = data[0].integritas_a;
      integritas_b = data[0].integritas_b;
      integritas_c = data[0].integritas_c;
      kerjasama_a = data[0].kerjasama_a;
      kerjasama_b = data[0].kerjasama_b;
      kerjasama_c = data[0].kerjasama_c;
      kerjasama_d = data[0].kerjasama_d;
      orientasi_thd_konsumen_a = data[0].orientasi_thd_konsumen_a;
      orientasi_thd_konsumen_b = data[0].orientasi_thd_konsumen_b;
      orientasi_thd_konsumen_c = data[0].orientasi_thd_konsumen_c;
      orientasi_thd_konsumen_d = data[0].orientasi_thd_konsumen_d;
      orientasi_thd_target_a = data[0].orientasi_thd_target_a;
      orientasi_thd_target_b = data[0].orientasi_thd_target_b;
      orientasi_thd_target_c = data[0].orientasi_thd_target_c;
      orientasi_thd_target_d = data[0].orientasi_thd_target_d;
      inisiatif_inovasi_a = data[0].inisiatif_inovasi_a;
      inisiatif_inovasi_b = data[0].inisiatif_inovasi_b;
      inisiatif_inovasi_c = data[0].inisiatif_inovasi_c;
      inisiatif_inovasi_d = data[0].inisiatif_inovasi_d;
      professionalisme_a = data[0].professionalisme_a;
      professionalisme_b = data[0].professionalisme_b;
      professionalisme_c = data[0].professionalisme_c;
      professionalisme_d = data[0].professionalisme_d;
      organizational_awareness_a = data[0].organizational_awareness_a;
      organizational_awareness_b = data[0].organizational_awareness_b;
      organizational_awareness_c = data[0].organizational_awareness_c;
      score_kpi = data[0].score_kpi;
    });
    return data;
  }

  String getMonthName(String monthNumber) {
    switch (monthNumber) {
      case '1':
        return 'January';
      case '2':
        return 'February';
      case '3':
        return 'March';
      case '4':
        return 'April';
      case '5':
        return 'May';
      case '6':
        return 'June';
      case '7':
        return 'July';
      case '8':
        return 'August';
      case '9':
        return 'September';
      case '10':
        return 'October';
      case '11':
        return 'November';
      case '12':
        return 'December';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Detail Kinerja', style: TextStyle(color: Colors.white)),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Score KPI
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.cyan,
                    child: Column(
                      children: [
                        Text(
                          'SCORE KPI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Divider(color: Colors.white, thickness: 0.5),
                        Text(
                          score_kpi,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        //periode
                        Text(
                          'Periode: ${getMonthName(bulan)} $tahun',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 16.0),

            //DISIPLIN
            // Table Header
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.grey[300],
              child: Text('Disiplin 30%',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 1.0),
            //header
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[300],
                    child: Text('No',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[300],
                    child: Text('Disiplin',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[300],
                    child: Text('Jumlah/Nilai',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            //kehadiran
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('1',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Kehadiran(25%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            // Data Rows
            buildTableRow('A', 'Jumlah kehadiran', jumlah_kehadiran),
            buildTableRow('B', 'Jumlah Izin', jumlah_izin),
            buildTableRow(
                'C', 'Jumlah Sakit Tanpa Ket', jumlah_sakit_tnp_ket_dokter),
            buildTableRow('D', 'Jumlah Mangkir', jumlah_mangkir),
            buildTableRow('E', 'Jumlah Terlambat', jumlah_terlambat),
            //seragam
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('2',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Seragam dan Penampilan(5%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            buildTableRow('A', 'Kebersihan Diri', kebersihan_diri),
            buildTableRow('B', 'Kerapian Penampilan', kerapihan_penampilan),
            SizedBox(height: 10.0), // Spacing

            //GENERAL COMPETENCY
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.grey[300],
              child: Text('General Competency 70%',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 1.0),
            //header
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[300],
                    child: Text('No',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[300],
                    child: Text('Kompetensi',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[300],
                    child: Text('Jumlah/Nilai',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            //Integritas
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('1',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Integritas(17%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            buildTableRow(
                'A',
                'Mampu bertindah secara konsisten sesuai standart minimal aturan dan target perusahaan yang berlaku',
                integritas_a),
            buildTableRow(
                'B',
                'Kejujuran dalam menyampaikan alasan/kendala ketika ada kendala yang mempengaruhi kinerja perusahaan',
                integritas_b),
            buildTableRow(
                'C',
                'Mampu mempertanggungjawabkan kesalahan yang telah dilakukan',
                integritas_c),
            //kerjasama
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('2',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Kerjasama(5%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            buildTableRow(
                'A',
                'Mampu memberikan feedback (masukan) kepada team kerjanya',
                kerjasama_a),
            buildTableRow(
                'B',
                'Mampu mengekspresikan gagasannya secara konstruktif',
                kerjasama_b),
            buildTableRow(
                'C',
                'Mampu menunjukan partisipasi aktif dalam kerja team',
                kerjasama_c),
            buildTableRow(
                'D',
                'Mampu menjalin silaturahim serta menciptakan hubungan yang baik dengan orang lain di luar kelompoknya',
                kerjasama_d),
            //orientasi thd konsumen
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('3',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Orientasi thd Konsumen(10%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            buildTableRow(
                'A',
                'Mampu memberikan pelayanan yang baik kepada konsumen/ calon konsumen melebihi standart minimal',
                orientasi_thd_konsumen_a),
            buildTableRow(
                'B',
                'Mampu menunjukan keinginan untuk menggali dan mengidentifikasi kebutuhan konsumen / calon konsumen',
                orientasi_thd_konsumen_b),
            buildTableRow(
                'C',
                'Mampu menunjukan kesungguhan dalam menanggapi pertanyaan atau permintaan konsumen / calon konsumen',
                orientasi_thd_konsumen_c),
            buildTableRow(
                'D',
                'Mampu memberikan tanggapan yang relevan dan mudah dimengerti atas permintaan konsumen / calon konsumen',
                orientasi_thd_konsumen_d),
            //orientasi thd target
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('4',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Orientasi thd Target(17%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            buildTableRow(
                'A',
                'Mampu menetapkan target kerjanya secara pribadi',
                orientasi_thd_target_a),
            buildTableRow(
                'B',
                'Mampu berusaha memenuhi target kerja pribadi yang telah ditetapkan',
                orientasi_thd_target_b),
            buildTableRow(
                'C',
                'Mampu aktif mencari masukan untuk mengembangkan performa kerja dirinya',
                orientasi_thd_target_c),
            buildTableRow(
                'D',
                'Mampu memanfaatkan pengalaman masa lalunya untuk meningkatkan kualitas kerjanya',
                orientasi_thd_target_d),
            //inisiatif inovasi
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('5',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Inisiatif dan Inovasi(8%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            buildTableRow(
                'A',
                'Mampu memahami standar kerja yang telah ditentukan oleh perusahaan atau unit kerjanya',
                inisiatif_inovasi_a),
            buildTableRow(
                'B',
                'Mampu menunjukan keingintahuan yang tinggi terhadap pekerjaan yang belum dikuasainya',
                inisiatif_inovasi_b),
            buildTableRow(
                'C',
                'Mampu mengaplikasikan pengetahuan yang didapat untuk meningkatkan performa kerja',
                inisiatif_inovasi_c),
            buildTableRow(
                'D',
                'Mampu menunjukan usaha yang konsisten untuk mengatasi masalah yang muncul',
                inisiatif_inovasi_d),
            //professionalisme
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('6',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Professionalisme(5%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            buildTableRow(
                'A',
                'Mampu menjelaskan tujuan dan target kerja di wilayah kerjanya secara jelas',
                professionalisme_a),
            buildTableRow(
                'B',
                'Mampu mempertanggungjawabkan pekerjaan yang menjadi tugasnya',
                professionalisme_b),
            buildTableRow(
                'C',
                'Mampu mengatasi tugas sulit yang dihadapi secara efektif',
                professionalisme_c),
            buildTableRow(
                'D',
                'Mampu untuk tidak menyalahkan dan atau mengungkap keburukan rekan kerja kepada kelompok lainnya',
                professionalisme_d),
            //organizational awareness
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('7',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text('Organizational Awareness(8%)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            buildTableRow(
                'A',
                'Mampu memahami peraturan dasar, khususnya yang berkaitan dengan hak dan kewajibannya sebagai karyawan',
                organizational_awareness_a),
            buildTableRow(
                'B',
                'Mampu memanfaatkan struktur formal di Garas Holding untuk mendukung aktivitas kerjanya (misalnya dengan mengetahui alur perintah otoritas setiap posisi)',
                organizational_awareness_b),
            buildTableRow(
                'C',
                'Mampu memahami SOP (standart Operating Procedure) terhadap aktivitas pekerjaan yang dilakukannya',
                organizational_awareness_c),
          ],
        ),
      ),
    );
  }

  Widget buildTableRow(String abjad, String isi, String jumlah) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(abjad),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(8.0),
            child: Text(isi),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(jumlah),
          ),
        ),
      ],
    );
  }
}
