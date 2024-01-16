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
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus data SharedPreferences
    Get.offAll(() => const Lo());
    //snackbar
    Get.snackbar(
      "Success",
      "Logout Success",
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ); // Pindah ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // User Profile Section
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
              onTap: () {
                _logout();
              },
            ),
          ),
        ],
      ),
    ));
  }
}
