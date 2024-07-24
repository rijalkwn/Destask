import 'dart:io';
import 'package:destask/controller/auth_controller.dart';
import 'package:destask/utils/constant_api.dart';

import '../../controller/user_controller.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/assets/file_pengguna/foto_user';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _usergroupController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserController userController = UserController();
  AuthController authController = AuthController();
  String namafoto = '';
  File? _image;
  bool isLoading = false;
  bool isFailed = false;
  String emaillama = '';
  String namalama = '';

  //mengambil gambar dari gallery
  Future getImageGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  //mengambil gambar dari camera
  Future getImageCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  //getdata user
  getDataUser() async {
    var data = await userController.getUserById();
    setState(() {
      _nameController.text = data[0].nama ?? '';
      namalama = data[0].nama ?? '';
      _emailController.text = data[0].email ?? '';
      emaillama = data[0].email ?? '';
      _usernameController.text = data[0].username ?? '';
      _usergroupController.text = data[0].id_usergroup ?? '';
      namafoto = data[0].foto_profil != null ? data[0].foto_profil : 'user.png';
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
    getIdUser();
  }

  @override
  Widget build(BuildContext context) {
    var iduser = Get.parameters['iduser'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Foto (Placeholder)
                buildPhotoField(),
                _image != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            : FilledButton.icon(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    bool uploadImage = await userController
                                        .uploadImage(_image!);
                                    if (uploadImage) {
                                      setState(() {
                                        _image = null;
                                      });
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        text: 'Foto berhasil diupdate!',
                                      );
                                    } else {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        title: 'Oops...',
                                        text: 'Foto gagal diupdate!',
                                      );
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } catch (e) {
                                    print(e);
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      title: 'Oops...',
                                      text:
                                          'Foto gagal diupdate, silahkan coba lagi!',
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.upload_outlined),
                                label: const Text('Update Foto',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                style: FilledButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                              ),
                      )
                    : const SizedBox(),
                // Nama

                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kolom Nama harus diisi';
                      }
                    },
                  ),
                ),
                //email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kolom Email harus diisi';
                    } else if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                  },
                ),

                // Username
                buildFormDisable("Username", _usernameController.text,
                    const Icon(Icons.person_outline)),

                // Usergroup
                buildFormDisable("Usergroup", _usergroupController.text,
                    const Icon(Icons.group_outlined)),

                // Tombol Simpan
                GestureDetector(
                  onTap: () async {
                    try {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        if (emaillama == _emailController.text &&
                            namalama == _nameController.text) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Oops...',
                            text: 'Tidak ada perubahan data!',
                          );
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          bool cekemail = await userController
                              .cekEmail(_emailController.text);

                          if (cekemail) {
                            bool update = await userController.editProfile(
                                _nameController.text, _emailController.text);
                            if (update) {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Profil berhasil diupdate!',
                              );
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Profil gagal diupdate!',
                              );
                            }
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: 'Email sudah terdaftar pada akun lain!',
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    } catch (e) {
                      print(e);
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Oops...',
                        text: 'Profil gagal diupdate, silahkan coba lagi!',
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
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

  Padding buildFormDisable(String label, String value, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: TextEditingController(text: value),
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildPhotoField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Stack(children: [
            CircleAvatar(
              radius: 100,
              child: _image == null
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            '$url/$namafoto',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: Image.file(_image!).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _image == null
                  ? GestureDetector(
                      onTap: () {
                        _showChoiceDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 25),
                        decoration: BoxDecoration(
                          color: GlobalColors.mainColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
            ),
          ]),
        ],
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
