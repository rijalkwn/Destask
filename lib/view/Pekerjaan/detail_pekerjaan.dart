// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:destask/controller/pekerjaan_controller.dart';

// class DetailPekerjaan extends StatefulWidget {
//   const DetailPekerjaan({Key? key}) : super(key: key);

//   @override
//   State<DetailPekerjaan> createState() => _DetailPekerjaanState();
// }

// class _DetailPekerjaanState extends State<DetailPekerjaan> {
//   final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
//   String idpekerjaan = '';
//   String namapekerjaan = '';
//   String deskripsipekerjaan = '';
//   String targetwaktuselesai = '';
//   String persentaseselesai = '';
//   String namapelanggan = '';
//   String jenislayanan = '';
//   String nominalharga = '';
//   String deskripsipekerjaan = '';
//   String targetwaktuselesai = '';
//   String persentaseselesai = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchData().then((data) {
//       setState(() {
//         idpekerjaan = data['idpekerjaan'] ?? '';
//         namapekerjaan = data['nama_task'] ?? '';
//         deskripsipekerjaan = data['deskripsi_task'] ?? '';
//         targetwaktuselesai = data['target_waktu_selesai'] ?? '';
//         persentaseselesai = data['persentase_selesai'] ?? '';
//         namapelanggan = data['nama_pelanggan'] ?? '';
//         jenislayanan = data['jenis_layanan'] ?? '';
//         nominalharga = data['nominal_harga'] ?? '';
//         deskripsipekerjaan = data['deskripsi_pekerjaan'] ?? '';
//         targetwaktuselesai = data['target_waktu_selesai'] ?? '';
//         persentaseselesai = data['persentase_selesai'] ?? '';
//       });
//     });
//   }

//   Future<Map<String, dynamic>> fetchData() async {
//     final String idPekerjaan = Get.parameters['idpekerjaan'] ?? '';
//     PekerjaanController pekerjaanController = PekerjaanController();
//     Map<String, dynamic> pekerjaan =
//         await pekerjaanController.getPekerjaanById(idPekerjaan);
//     return pekerjaan;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Pekerjaan'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available'));
//           } else {
//             Map<String, dynamic> pekerjaan = snapshot.data!;
//             return buildJobDetailCard(pekerjaan);
//           }
//         },
//       ),
//     );
//   }

//   Widget buildJobDetailCard(Map<String, dynamic> pekerjaan) {
//     return Card(
//       margin: EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             title: Text(
//               'ID Pekerjaan: ${pekerjaan["id_pekerjaan"]}',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text('Nama Pekerjaan: ${pekerjaan["nama_pekerjaan"]}'),
//           ),
//           Divider(),
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text('Field')),
//                 DataColumn(label: Text('Value')),
//               ],
//               rows: [
//                 DataRow(cells: [
//                   DataCell(Text('Pelanggan')),
//                   DataCell(Text('${pekerjaan["pelanggan"]}')),
//                 ]),
//                 DataRow(cells: [
//                   DataCell(Text('Jenis Layanan')),
//                   DataCell(Text('${pekerjaan["jenis_layanan"]}')),
//                 ]),
//                 DataRow(cells: [
//                   DataCell(Text('Nominal Harga')),
//                   DataCell(Text('${pekerjaan["nominal_harga"]}')),
//                 ]),
//                 DataRow(cells: [
//                   DataCell(Text('Deskripsi Pekerjaan')),
//                   DataCell(Text('${pekerjaan["deskripsi_pekerjaan"]}')),
//                 ]),
//                 DataRow(cells: [
//                   DataCell(Text('Target Waktu Selesai')),
//                   DataCell(Text('${pekerjaan["target_waktu_selesai"]}')),
//                 ]),
//                 DataRow(cells: [
//                   DataCell(Text('Persentase Selesai')),
//                   DataCell(Text('${pekerjaan["persentase_selesai"]}')),
//                 ]),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
