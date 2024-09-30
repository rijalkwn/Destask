import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../controller/kategori_task_controller.dart';
import '../../../controller/task_controller.dart';
import '../../../model/kategori_task_model.dart';
import 'package:quickalert/quickalert.dart';
import '../../../controller/status_task_controller.dart';
import '../../../model/status_task_model.dart';
import '../../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class SubmitTask extends StatefulWidget {
  const SubmitTask({super.key});

  @override
  State<SubmitTask> createState() => _SubmitTaskState();
}

class _SubmitTaskState extends State<SubmitTask> {
  final String idTask = Get.parameters['idtask'] ?? '';
  final TextEditingController _deskripsiTaskController =
      TextEditingController();
  final TextEditingController _persentaseSelesaiController =
      TextEditingController();
  final TextEditingController _tautanTaskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StatusTaskController statusTaskController = StatusTaskController();
  KategoriTaskController kategoriTaskController = KategoriTaskController();
  TaskController taskController = TaskController();
  // File? _image;
  // String namafoto = '';
  bool isLoading = false;
  String idPekerjaan = "";
  String namaPekerjaan = "";
  String namaKategori = "";
  String idStatusTask = "";
  String idKategoriTask = "";
  File? _selectedFile;
  String? _fileName;
  DateTime targetWaktuSelesai = DateTime.now();
  late Future<List<StatusTaskModel>> statusList;
  late Future<List<KategoriTaskModel>> kategoriList;

  @override
  void initState() {
    super.initState();
    statusList = statusTaskController.showAllTask();
    kategoriList = kategoriTaskController.showAll();
    taskController.showById(idTask).then((value) {
      setState(() {
        idPekerjaan = value[0].id_pekerjaan.toString();
        _deskripsiTaskController.text = value[0].deskripsi_task.toString();
        _persentaseSelesaiController.text =
            value[0].persentase_selesai.toString();
        _selectedDateStart = DateTime.parse(value[0].tgl_planing.toString());
        idStatusTask = value[0].id_status_task.toString();
        idKategoriTask = value[0].id_kategori_task.toString();
        targetWaktuSelesai = DateTime.parse(value[0].tgl_planing.toString());
        _tautanTaskController.text = value[0].tautan_task.toString();
        _persentaseSelesaiController.text =
            value[0].persentase_selesai.toString();
        namaPekerjaan = value[0].data_tambahan.nama_pekerjaan.toString();
        namaKategori = value[0].data_tambahan.nama_kategori_task.toString();
      });
      return value;
    });
  }

  //date picker
  DateTime? _selectedDateStart;

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateStart ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDateStart) {
      setState(() {
        _selectedDateStart = pickedDate;
      });
    }
  }

  //mengambil gambar dari galeri
  // Future getImageGallery() async {
  //   var image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image = File(image!.path);
  //     namafoto = _image!.path.split('/').last;
  //   });
  // }

  //mengambil gambar dari camera
  // Future getImageCamera() async {
  //   var image = await ImagePicker().pickImage(source: ImageSource.camera);
  //   setState(() {
  //     _image = File(image!.path);
  //     namafoto = _image!.path.split('/').last;
  //   });
  // }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      int fileSizeInBytes = await file.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB <= 5) {
        setState(() {
          _selectedFile = file;
          _fileName = result.files.single.name;
        });
      } else {
        // File exceeds the maximum allowed size
        setState(() {
          _selectedFile = null;
          _fileName = null;
        });
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Maksimal ukuran file adalah 5MB, ukuran file saat ini: ${fileSizeInMB.toStringAsFixed(2)}MB'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // User canceled the picker
      setState(() {
        _selectedFile = null;
        _fileName = null;
      });
    }
  }

  @override
  void dispose() {
    _deskripsiTaskController.dispose();
    _persentaseSelesaiController.dispose();
    _tautanTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        title: const Text('Submit Task', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //deskripsi task
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildLabel('Pekejaan *'),
                    formDisabled(namaPekerjaan),
                    const SizedBox(height: 16),
                    buildLabel('Deskripsi Task *'),
                    formDisabled(_deskripsiTaskController.text),
                    const SizedBox(height: 16),

                    //tanggal mulai
                    buildLabel('Target Waktu Selesai *'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Row(
                        children: [
                          //icon tanggal
                          Icon(Icons.calendar_today,
                              color: Colors.grey, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            formatDate(targetWaktuSelesai),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    //kategori task
                    buildLabel('Kategori Task *'),
                    formDisabled(namaKategori),
                    const SizedBox(height: 16),
                  ],
                ),
                buildLabel('Tautan Task *'),
                const Text(
                    '*Berupa url pengerjaan task, seperti link GitHub, Drive, dsb. jika tidak ada isi dengan keterangan kenapa tidak ada.',
                    style: TextStyle(
                      color: Colors.red,
                    )),
                buildFormField(
                    _tautanTaskController, "Tautan Task", TextInputType.text),
                const SizedBox(height: 16),
                buildLabel('Bukti Selesai *'),
                Text('*Maksimal ukuran file adalah 5MB!!',
                    style: TextStyle(
                      color: Colors.red,
                    )),
                buildbuktiselesai(context),
                //tamplkan gambar

                const SizedBox(height: 35),

                //button
                GestureDetector(
                  onTap: () async {
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        if (_selectedFile != null) {
                          bool success = await taskController.submitDataTask(
                            idTask,
                            _tautanTaskController.text,
                            _selectedFile!,
                          );
                          if (success == true) {
                            Get.offAndToNamed('/task/$idPekerjaan');
                            QuickAlert.show(
                                context: context,
                                title: "Submit Task Berhasil",
                                type: QuickAlertType.success);
                          } else {
                            QuickAlert.show(
                                context: context,
                                title: "Submit Task Gagal",
                                type: QuickAlertType.error);
                          }

                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          QuickAlert.show(
                            context: context,
                            title: "Pilih file bukti selesai",
                            type: QuickAlertType.error,
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } catch (e) {
                      print('Error submit task: $e');
                    }
                  },
                  child: isLoading
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ))
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Submit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buildbuktiselesai(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.all(15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Text(
                    'Pilih File',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_outlined),
                    padding: EdgeInsets.zero,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    getFile();
                    Get.back();
                  },
                  icon: const Icon(Icons.collections_outlined),
                  label: const Text(
                    'File',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.upload_file),
            const SizedBox(width: 16),
            if (_selectedFile != null)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _fileName ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFile = null;
                          _fileName = '';
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            else
              const Expanded(
                child: Text(
                  'Pilih File *',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

TextFormField buildFormField(
    TextEditingController controller, String label, TextInputType type) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    // enabled: false,
    decoration: const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Kolom $label harus diisi';
      }
      return null;
    },
  );
}

TextFormField buildFormFieldPersentase(
    TextEditingController controller, String label, TextInputType type) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    decoration: const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      border: OutlineInputBorder(),
      suffixText: '%', // Tambahkan simbol % di ujung kanan
      suffixStyle: const TextStyle(fontSize: 16),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Kolom $label harus diisi';
      }
      int? val = int.tryParse(value);
      if (val == null || val < 0 || val > 100) {
        return 'Nilai harus antara 0 dan 100';
      }
      return null;
    },
  );
}

Widget buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Container formDisabled(String nama) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(5),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    child: Text(
      nama,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    ),
  );
}

//format date
String formatDate(DateTime date) {
  return DateFormat('dd MMMM yyyy').format(date);
}
