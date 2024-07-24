import 'dart:async';
import 'dart:io';
import 'package:destask/utils/constant_api.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../controller/task_controller.dart';
import '../../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class DetailVerifikasi extends StatefulWidget {
  const DetailVerifikasi({Key? key}) : super(key: key);

  @override
  State<DetailVerifikasi> createState() => _DetailVerifikasiState();
}

class _DetailVerifikasiState extends State<DetailVerifikasi> {
  var url = '$baseURL/assets/bukti_task';
  final String idtask = Get.parameters['idtask'] ?? '';
  TaskController taskController = TaskController();

  //kolom task
  String idTask = '';
  String idPekerjaan = '';
  String idUser = '';
  String creator = '';
  String idStatusTask = '';
  String idKategoriTask = '';
  DateTime tglPlaning = DateTime.now();
  String tglSelesai = '';
  String tglVerifikasiDiterima = '';
  String persentaseSelesai = '';
  String deskripsiTask = '';
  String alasanVerifikasi = '';
  String buktiSelesai = '';
  String tautanTask = '';
  String statusVerifikasi = '';
  String namaVerifikator = '';
  double _progress = 0;
  bool muncul = false;
  bool _isDownloading = false;

  //bantuan
  String namaCreator = '';
  String namaUserTask = '';
  String namaPekerjaan = '';
  String namaStatusTask = '';
  String namaKategoriTask = '';
  bool isLoading = false;

  void download(String urlfile) async {
    String trimmedUrl = urlfile.trim();
    print('Downloading file from: $trimmedUrl');

    // Set a timeout duration
    const timeoutDuration = Duration(seconds: 25);

    setState(() {
      _isDownloading = true;
    });

    // Start the download
    Future<void> downloadTask = FileDownloader.downloadFile(
      url: urlfile.trim(),
      onProgress: (name, progress) {
        setState(() {
          _progress = progress;
        });
      },
      onDownloadCompleted: (value) {
        setState(() {
          _progress = 0;
          _isDownloading = false;
        });
        Get.snackbar(
          'Berhasil Mengunduh File',
          'File Bukti Selesai berhasil diunduh',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onDownloadError: (error) {
        print('Error: $error');
        setState(() {
          _progress = 0;
          _isDownloading = false;
        });
        Get.snackbar(
          'Gagal Mengunduh File',
          'Terjadi kesalahan saat mengunduh file: $error',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );

    // Handle the timeout
    try {
      await downloadTask.timeout(timeoutDuration);
    } on TimeoutException catch (_) {
      if (_isDownloading) {
        setState(() {
          _progress = 0;
          _isDownloading = false;
        });
        Get.snackbar(
          'Gagal Mengunduh File',
          'Proses unduh melebihi batas waktu. Silakan coba lagi.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  getDataTask() async {
    var data = await taskController.getTaskById(idtask);
    setState(() {
      idTask = data[0].id_task ?? '-';
      idPekerjaan = data[0].id_pekerjaan ?? '-';
      idUser = data[0].id_user ?? '-';
      creator = data[0].creator ?? '-';
      idStatusTask = data[0].id_status_task ?? '-';
      idKategoriTask = data[0].id_kategori_task ?? '-';
      tglPlaning = DateTime.parse(data[0].tgl_planing.toString());
      tglSelesai = data[0].tgl_selesai.toString() == 'null'
          ? '-'
          : data[0].tgl_selesai.toString();
      tglVerifikasiDiterima = data[0].tgl_verifikasi_diterima == null
          ? '-'
          : data[0].tgl_verifikasi_diterima.toString();
      persentaseSelesai = data[0].persentase_selesai ?? '-';
      deskripsiTask = data[0].deskripsi_task ?? '-';
      alasanVerifikasi = data[0].alasan_verifikasi ?? '-';
      buktiSelesai = data[0].bukti_selesai ?? '';
      tautanTask = data[0].tautan_task ?? '-';
      namaUserTask = data[0].data_tambahan.nama_user;
      namaCreator = data[0].data_tambahan.nama_creator;
      namaPekerjaan = data[0].data_tambahan.nama_pekerjaan;
      namaStatusTask = data[0].data_tambahan.nama_status_task;
      namaKategoriTask = data[0].data_tambahan.nama_kategori_task;
      namaVerifikator = data[0].data_tambahan.nama_verifikator;
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Detail Task",
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
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    deskripsiTask,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Personil: $namaUserTask',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: GlobalColors.mainColor,
                    child: Text(
                      '$persentaseSelesai%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //status task
                    detail('Status Task', namaStatusTask),
                    //kategori task
                    detail('Kategori Task', namaKategoriTask),
                    //pekerjaan
                    detail('Pekerjaan', namaPekerjaan),
                    //tanggal planing
                    detail('Target Waktu Selesai',
                        formatDate(tglPlaning.toString())),
                    //tanggal selesai
                    detail('Tanggal Selesai', formatDate(tglSelesai)),
                    //tanggal verifikasi diterima
                    detail('Tanggal Verifikasi Diterima',
                        formatDateTime(tglVerifikasiDiterima)),
                    //verifikator
                    namaVerifikator == ''
                        ? Container()
                        : detail('Verifikator', namaVerifikator),
                    //tautan task
                    tautanTask == ''
                        ? Container()
                        : detailtautan(context, 'Tautan Task', tautanTask),
                    //bukti selesai
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Bukti Selesai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buktiSelesai == '' ? Container() : buktiselesai(context),
                    //alasan verifikasi
                    alasanVerifikasi == ''
                        ? Container()
                        : detail('Alasan Verifikasi Ditolak', alasanVerifikasi),
                    //fungsi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //menampilkan dialog isinya form alasan verifikasi
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String alasanVerifikasiLocal = '';
                                  return AlertDialog(
                                    title: const Text('Tolak Task Ini?'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Alasan menolak **'),
                                            TextField(
                                              onChanged: (value) {
                                                alasanVerifikasiLocal = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (alasanVerifikasiLocal.isEmpty) {
                                            QuickAlert.show(
                                              context: context,
                                              title:
                                                  "Alasan tidak boleh kosong",
                                              type: QuickAlertType.warning,
                                            );
                                            return;
                                          }
                                          Navigator.pop(context);
                                          setState(() {
                                            isLoading = true;
                                          });
                                          bool success = await taskController
                                              .editTaskVerikasiTolak(idTask,
                                                  alasanVerifikasiLocal);

                                          // Jika verifikasi task berhasil, Anda dapat menambahkan logika penanganan berhasil di sini
                                          if (success) {
                                            Get.offAndToNamed(
                                                '/verifikasi_task/$idPekerjaan');
                                            Get.snackbar(
                                              'Berhasil',
                                              'Task berhasil ditolak',
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            Get.snackbar(
                                              'Gagal',
                                              'Task gagal ditolak',
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        child: isLoading
                                            ? const CircularProgressIndicator()
                                            : const Text('Tolak'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Center(
                                child: Text(
                                  'Tolak',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        //terima verifikasi
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //menampilkan dialog yakin menerima verifikasi
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Yakin Terima Task Ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(
                                              context); // Close the dialog immediately

                                          setState(() {
                                            isLoading = true;
                                          });

                                          // Perform the asynchronous operation
                                          bool success = await taskController
                                              .editTaskVerikasiDiterima(idTask);

                                          // Handle the result of the asynchronous operation
                                          if (success) {
                                            Get.offAndToNamed(
                                                '/verifikasi_task/$idPekerjaan');
                                            Get.snackbar(
                                              'Berhasil',
                                              'Task berhasil diterima',
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            Get.snackbar(
                                              'Gagal',
                                              'Task gagal diterima',
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          }

                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        child: const Text('Terima'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: GlobalColors.mainColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Center(
                                child: Text(
                                  'Terima',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              //bukti selesai
            ],
          ),
        ),
      ),
    );
  }

  Column buktiselesai(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //bukti selesai
        const Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Bukti Selesai',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              buktiSelesai != ''
                  ? Column(
                      children: [
                        _isDownloading == false
                            ? GestureDetector(
                                onTap: () async {
                                  final fileUrl = '$url/$buktiSelesai';
                                  // Download file menggunakan flutter_downloader
                                  download(fileUrl);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        buktiSelesai.length > 35
                                            ? '${buktiSelesai.substring(0, 25)}...${buktiSelesai.substring(buktiSelesai.length - 5)}'
                                            : buktiSelesai,
                                        overflow: TextOverflow
                                            .ellipsis, // Handles text overflow gracefully
                                      ),
                                    ),
                                    Icon(
                                      Icons.download_for_offline_sharp,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Downloading...',
                                      overflow: TextOverflow
                                          .ellipsis, // Optionally add ellipsis for overflow handling
                                    ),
                                  ),
                                  const CircularProgressIndicator(
                                    backgroundColor: Colors.grey,
                                  ),
                                ],
                              ),
                        Divider(),
                        SizedBox(height: 8),
                        (buktiSelesai.endsWith('.png') ||
                                buktiSelesai.endsWith('.jpeg') ||
                                buktiSelesai.endsWith('.jpg'))
                            ? muncul == false
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        muncul = true;
                                      });
                                    },

                                    // button
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Lihat Bukti',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        muncul = false;
                                      });
                                    },

                                    // button
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Tutup Bukti',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                            : Container(),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 16),
              muncul == true
                  ? Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: Image.network(
                        '$url/$buktiSelesai',
                        fit: BoxFit.contain, // Sesuaikan sesuai kebutuhan
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Container detailtautan(BuildContext context, String judul, String link) {
    bool isValidLink(String url) {
      final Uri? uri = Uri.tryParse(url);
      return uri != null &&
          (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              isValidLink(link)
                  ? Expanded(
                      child: Text(
                        link,
                        style: const TextStyle(color: Colors.blue),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Expanded(
                      child: Text(
                        link,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
              if (isValidLink(link))
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.blue, size: 20),
                  onPressed: () {
                    if (link.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: link));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tautan berhasil disalin!'),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
          Divider(),
        ],
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 8),
          Text(isi, style: const TextStyle(fontSize: 14)),
          Divider(),
        ],
      ),
    );
  }

  //format tanggal
  String formatDate(String date) {
    if (date == '-') {
      return '-';
    }
    try {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('d MMMM yyyy', 'id').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  String formatDateTime(String date) {
    if (date == '-') {
      return '-';
    }
    try {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('d MMMM yyyy HH:mm', 'id').format(dateTime);
    } catch (e) {
      return '-';
    }
  }
}
