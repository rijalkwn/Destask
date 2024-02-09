import 'dart:io';
import 'package:destask/utils/constant_api.dart';

import '../../controller/user_controller.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/api/user/fotoprofil';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _usergroupController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserController userController = UserController();
  String namafoto = '';
  File? _image;
  bool isUploading = false;
  bool isFailed = false;

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return token;
  }

  getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    return idUser;
  }

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
    var iduser = await getIdUser();
    var data = await userController.getUserById(iduser);
    setState(() {
      _nameController.text = data[0].nama;
      _emailController.text = data[0].email;
      _usernameController.text = data[0].username;
      _usergroupController.text = data[0].id_usergroup;
      namafoto = data[0].foto_profil;
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
        title: Text('Edit Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Foto (Placeholder)
                buildPhotoField(),
                // Nama
                buildTextField("Nama", _nameController, iconData: Icons.person),

                // Email
                buildTextField("Email", _emailController,
                    keyboardType: TextInputType.emailAddress,
                    iconData: Icons.email),

                // Username
                buildTextField("Username", _usernameController,
                    iconData: Icons.person_outline),

                // Usergroup
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _usergroupController,
                    decoration: InputDecoration(
                      labelText: 'Usergroup',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.group),
                    ),
                    enabled: false,
                  ),
                ),

                // Tombol Simpan
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      UserController userController = UserController();
                      bool editProfile = await userController.editProfile(
                          iduser,
                          _nameController.text,
                          _emailController.text,
                          _usernameController.text);
                      if (editProfile) {
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
                          text: 'Profil gagal diupdate, silahkan coba lagi!',
                        );
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
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

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, IconData? iconData}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: iconData != null ? Icon(iconData) : null,
        ),
      ),
    );
  }

  Widget buildPhotoField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
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
                            '$baseURL/assets/foto_profil/$namafoto',
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
            if (_image != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
          ]),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              if (_image != null) {
                setState(() {
                  isUploading = true;
                });
                // Jika gambar sudah dipilih, maka lakukan upload
                bool success = await userController.uploadImage(_image!);
                if (success) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'Foto berhasil diupload!',
                  );
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Oops...',
                    text: 'Foto gagal diupload, silahkan coba lagi!',
                  );
                }
                setState(() {
                  isUploading = false;
                });
              } else {
                // Jika belum, tampilkan dialog pilihan
                _showChoiceDialog(context);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
              decoration: BoxDecoration(
                color: GlobalColors.mainColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: _image == null
                  ? Text(
                      'Ganti Foto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    )
                  : Text(
                      'Upload Foto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
            ),
          ),
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
