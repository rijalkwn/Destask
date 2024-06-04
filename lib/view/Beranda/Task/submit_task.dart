import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/kategori_task_controller.dart';
import '../../../controller/task_controller.dart';
import '../../../model/kategori_task_model.dart';
import 'package:quickalert/quickalert.dart';
import '../../../controller/status_task_controller.dart';
import '../../../model/status_task_model.dart';
import '../../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  File? _image;
  String namafoto = '';
  bool isLoading = false;
  String idPekerjaan = "";
  String namaPekerjaan = "";
  String idStatusTask = "";
  String idKategoriTask = "";
  List<StatusTaskModel> statusList = [];
  List<KategoriTaskModel> kategoriList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      statusList = await statusTaskController.showAll();
      kategoriList = await kategoriTaskController.showAll();
      taskController.showById(idTask).then((value) {
        setState(() {
          idPekerjaan = value[0].id_pekerjaan.toString();
          _deskripsiTaskController.text = value[0].deskripsi_task.toString();
          _persentaseSelesaiController.text =
              value[0].persentase_selesai.toString();
          _selectedDateStart = DateTime.parse(value[0].tgl_planing.toString());
          idStatusTask = value[0].id_status_task.toString();
          idKategoriTask = value[0].id_kategori_task.toString();
          _tautanTaskController.text = value[0].tautan_task.toString();
          _persentaseSelesaiController.text =
              value[0].persentase_selesai.toString();
          namaPekerjaan = value[0].data_tambahan.nama_pekerjaan.toString();
        });
        return value;
      });
    } catch (e) {
      print('Error loading data: $e');
      QuickAlert.show(
        context: context,
        title: "Gagal Memuat Data",
        type: QuickAlertType.error,
      );
    }
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
  Future getImageGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
      namafoto = _image!.path.split('/').last;
    });
  }

  //mengambil gambar dari camera
  Future getImageCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
      namafoto = _image!.path.split('/').last;
    });
  }

  //mengambil file
  // Future getFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: [
  //       'pdf',
  //       'doc',
  //       'docx',
  //       'xls',
  //       'xlsx',
  //       'ppt',
  //       'pptx',
  //       'jpg',
  //       'jpeg',
  //       'png',
  //       'zip',
  //       'rar'
  //     ],
  //   );
  //   if (result != null) {
  //     setState(() {
  //       _file = File(result.files.single.path!);
  //       namafile = _file!.path.split('/').last;
  //     });
  //   } else {
  //     // User canceled the picker
  //     print('User canceled the picker');
  //   }
  // }

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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Text(
                        namaPekerjaan,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Deskripsi Task *'),
                    buildFormField(_deskripsiTaskController, 'Deskripsi Task',
                        TextInputType.multiline),
                    const SizedBox(height: 16),

                    //tanggal mulai
                    buildLabel('Deadline *'),
                    TextFormField(
                      controller: TextEditingController(
                          text: _selectedDateStart != null
                              ? "${_selectedDateStart!.day}/${_selectedDateStart!.month}/${_selectedDateStart!.year}"
                              : ""),
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kolom Tanggal Deadline harus diisi';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    //kategori task
                    buildLabel('Kategori Task *'),
                    idKategoriTask == ""
                        ? const Text("Memuat data")
                        : DropdownButtonFormField<String>(
                            value: idKategoriTask,
                            // onChanged: (value) {
                            //   setState(() {
                            //     idKategoriTask = value!;
                            //   });
                            // },
                            onChanged: null,
                            items: kategoriList.map((kategori) {
                              return DropdownMenuItem<String>(
                                value: kategori.id_kategori_task,
                                child: Text(
                                    kategori.nama_kategori_task.toString()),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 3),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kolom Kategori Task harus diisi';
                              }
                              return null;
                            },
                          ),
                    const SizedBox(height: 16),
                    // buildLabel('Status Task *'),
                    // idStatusTask == ""
                    //     ? const Text("Memuat data")
                    //     : DropdownButtonFormField<String>(
                    //         value: idStatusTask,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             idStatusTask = value!;
                    //           });
                    //         },
                    //         items: statusList.map((status) {
                    //           return DropdownMenuItem<String>(
                    //             value: status.id_status_task,
                    //             child: Text(status.nama_status_task.toString()),
                    //           );
                    //         }).toList(),
                    //         decoration: const InputDecoration(
                    //           contentPadding: EdgeInsets.symmetric(
                    //               horizontal: 15, vertical: 3),
                    //           border: OutlineInputBorder(),
                    //         ),
                    //         validator: (value) {
                    //           if (value == null || value.isEmpty) {
                    //             return 'Kolom Status Task harus diisi';
                    //           }
                    //           return null;
                    //         },
                    //       ),
                    // const SizedBox(height: 16),
                    //persentase selesai
                    // buildLabel('Persentase Selesai *'),
                    // buildFormFieldPersentase(_persentaseSelesaiController,
                    //     'Persentase Selesai', TextInputType.number),
                    // const SizedBox(height: 5),
                  ],
                ),
                const SizedBox(height: 10),
                // Checkbox completed
                buildLabel('Tautan Task'),
                buildFormFieldBolehKosong(
                    _tautanTaskController, "Tautan Task", TextInputType.url),
                const SizedBox(height: 16),
                buildLabel('Bukti Selesai *'),
                GestureDetector(
                  onTap: () {
                    _showChoiceDialog(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.upload_file),
                        const SizedBox(width: 16),
                        if (_image != null)
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    // namafile,
                                    namafoto,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                //hapus gambar
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // _file = null;
                                      // namafile = '';
                                      _image = null;
                                      namafoto = '';
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
                ),
                //tamplkan gambar
                _image != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Image.file(
                          _image!,
                          width: 100,
                        ),
                      )
                    : Container(),

                const SizedBox(height: 35),

                //button
                GestureDetector(
                  onTap: () async {
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      if (_formKey.currentState!.validate() && _image != null) {
                        bool success = await taskController.uploadImage(
                          idTask,
                          _tautanTaskController.text,
                          _image!,
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
                        setState(() {
                          isLoading = false;
                        });
                        //warning
                        QuickAlert.show(
                          context: context,
                          title:
                              "Pastikan file bukti selesai sudah terisi dan valid",
                          type: QuickAlertType.error,
                        );
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
                            'Submit Task',
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

  TextFormField buildFormField(
      TextEditingController controller, String label, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      readOnly: true,
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

  TextFormField buildFormFieldBolehKosong(
      TextEditingController controller, String label, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text('Pilih Gambar',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              trailing: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close_outlined),
                padding: EdgeInsets.zero,
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                getImageGallery();
                Get.back();
              },
              icon: const Icon(Icons.collections_outlined),
              label: const Text('Galeri',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            FilledButton.icon(
              onPressed: () {
                getImageCamera();
                Get.back();
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Kamera',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            )
          ],
        );
      },
    );
  }
}

class DetailImagePage extends StatelessWidget {
  final File image;

  const DetailImagePage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag:
                'imageHero', // Tag hero harus sama dengan tag yang digunakan di halaman sebelumnya
            child: Image.file(image),
          ),
        ),
      ),
    );
  }
}
