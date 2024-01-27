import 'package:destask/controller/auth_controller.dart';
import 'package:destask/controller/profile_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pengaturan extends StatefulWidget {
  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  String nama = '';
  String email = '';
  String id = '';

  Future<String?> showData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var iduser = pref.getString('id_user');
    return iduser;
  }

  @override
  void initState() {
    super.initState();
    showData().then((iduser) {
      if (iduser != null) {
        fetchData(iduser);
      } else {
        print('id_user is null');
      }
    });
  }

  Future<void> fetchData(String iduser) async {
    try {
      if (iduser != null) {
        ProfileController profileController = ProfileController();
        Map<String, dynamic>? datauser =
            await profileController.getProfileById(iduser);
        if (datauser != null) {
          setState(() {
            id = datauser['id_user'] ?? '';
            nama = datauser['nama'] ?? '';
            email = datauser['email'] ?? '';
          });
        } else {
          print('User data is null or empty');
        }
      } else {
        print('id_user is null');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/img/logo.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    nama,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    email,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            //edit profile
            Card(
              child: ListTile(
                iconColor: Colors.black,
                title: Text('Edit Profil'),
                leading: Icon(
                  Icons.person_2,
                  size: 20,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: 15,
                ),
                onTap: () {
                  Get.toNamed('/edit_profile/$id');
                },
              ),
            ),
            // Change Password
            Card(
              child: ListTile(
                iconColor: Colors.black,
                title: Text('Ganti Password'),
                leading: Icon(
                  Icons.vpn_key_rounded,
                  size: 20,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: 15,
                ),
                onTap: () {
                  Get.toNamed('/ganti_password');
                },
              ),
            ),
            // Logout
            Card(
              child: ListTile(
                title: Text('Logout'),
                leading: Icon(
                  Icons.logout_outlined,
                  size: 20,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: 15,
                ),
                onTap: () async {
                  AuthController authController = AuthController();
                  bool cekLogout = await authController.logout();
                  if (cekLogout) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Logout Berhasil!',
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops...',
                      text: 'Logout Gagal, Silahkan Coba Lagi!',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
