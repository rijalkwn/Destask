import 'dart:io';
import '../../controller/user_controller.dart';
import '../../utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  File? Image;
  String? fileImageName;

  //get user
  getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    return idUser;
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
    });
    return data;
  }

  //pick image
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? imagePicked =
          await picker.pickImage(source: ImageSource.gallery);
      Image = File(imagePicked!.path);
      setState(() {
        fileImageName = imagePicked.name;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
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
          CircleAvatar(
            radius: 100,
            backgroundImage: Image != null
                ? FileImage(Image!)
                : AssetImage('assets/img/logo.png') as ImageProvider,
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              await _pickImage();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
              decoration: BoxDecoration(
                color: GlobalColors.mainColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                'Ubah Foto',
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
}
