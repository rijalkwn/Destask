import 'package:destask/controller/auth_controller.dart';
import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/Pengaturan/profil.dart';
import 'package:destask/view/lo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        color: GlobalColors.backColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://placekitten.com/200/200'), // Ganti dengan URL foto profil pengguna
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Rijal Kurniawan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "admin@mail.com",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Edit Profile Button
            GestureDetector(
              onTap: () {
                Get.to(() => Profil());
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: GlobalColors.mainColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.edit, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            // Change Password
            Card(
              child: ListTile(
                iconColor: Colors.black,
                title: Text('Ganti Password'),
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
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: 15,
                ),
                onTap: () async {
                  AuthController authController = AuthController();
                  await authController.logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
