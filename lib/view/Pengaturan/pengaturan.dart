import 'package:destask/utils/constant_api.dart';

import '../../controller/auth_controller.dart';
import '../../controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = '$baseURL/assets/foto_profil';

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  UserController userController = UserController();
  String nama = '';
  String email = '';
  String idUser = '';
  String fotoProfil = 'user.png';

  Future getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString("id_user");
    return idUser;
  }

  getDataUser() async {
    var iduser = await getIdUser();
    var data = await userController.getUserById(iduser);
    if (data != null && data.isNotEmpty) {
      setState(() {
        idUser = data[0].id_user != null ? data[0].id_user : '';
        nama = data[0].nama != null ? data[0].nama : '';
        email = data[0].email != null ? data[0].email : '';
        fotoProfil =
            data[0].foto_profil != null ? data[0].foto_profil : 'user.png';
      });
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
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
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      '$url/$fotoProfil',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nama,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            //edit profile
            Card(
              child: ListTile(
                iconColor: Colors.black,
                title: const Text('Edit Profil'),
                leading: const Icon(
                  Icons.person_2,
                  size: 20,
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 15,
                ),
                onTap: () {
                  Get.toNamed('/edit_profile/$idUser');
                },
              ),
            ),
            // Change Password
            Card(
              child: ListTile(
                iconColor: Colors.black,
                title: const Text('Ganti Password'),
                leading: const Icon(
                  Icons.vpn_key_rounded,
                  size: 20,
                ),
                trailing: const Icon(
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
                title: const Text('Logout'),
                leading: const Icon(
                  Icons.logout_outlined,
                  size: 20,
                ),
                trailing: const Icon(
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
