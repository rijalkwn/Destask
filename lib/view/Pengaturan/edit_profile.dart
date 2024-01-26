import 'package:destask/controller/profile_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

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
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;

  Future<Map<String, dynamic>> fetchData() async {
    var iduser = Get.parameters['iduser'] ?? '';
    ProfileController profileController = ProfileController();
    Map<String, dynamic> profile =
        await profileController.getProfileById(iduser);
    return profile;
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final pickedImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _pickedImage = pickedImage;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((profile) {
      if (profile != null) {
        setState(() {
          _nameController.text = profile['nama'] ?? '';
          _emailController.text = profile['email'] ?? '';
          _usernameController.text = profile['username'] ?? '';
          _usergroupController.text = profile['id_usergroup'] ?? '';
        });
      } else {
        print('Profile is null');
      }
    });
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
                      ProfileController profileController = ProfileController();
                      bool editProfile = await profileController.editProfil(
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
            radius: 40,
            //   backgroundImage: _pickedImage != null
            //       ? FileImage(File(_pickedImage!.path))
            //       : AssetImage('assets/img/logo.png'),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: _pickImage,
            child: Text('Ganti Foto'),
          ),
        ],
      ),
    );
  }
}
