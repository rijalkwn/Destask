import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _usergroupController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _usergroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              buildTextField("Usergroup", _usergroupController,
                  iconData: Icons.group),

              // Tombol Simpan
              GestureDetector(
                onTap: () {
                  // Tambahkan logika penyimpanan data di sini
                  // Sesuaikan dengan kebutuhan Anda
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
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, IconData? iconData}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
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
            backgroundImage: NetworkImage(
                'https://placekitten.com/200/200'), // Ganti dengan URL foto profil pengguna
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // Tambahkan logika pengambilan foto atau pilih foto dari galeri di sini
              // Sesuaikan dengan kebutuhan Anda
            },
            child: Text('Ganti Foto'),
          ),
        ],
      ),
    );
  }
}
