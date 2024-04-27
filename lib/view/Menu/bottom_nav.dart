import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/global_colors.dart';
import '../../view/Beranda/beranda.dart';
import '../../view/RekapPoint/rekap_point.dart';
import '../../view/Pekerjaan/pekerjaan.dart';
import '../../view/Pengaturan/pengaturan.dart';

import '../../view/verifikasi/verifikasi.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool supervisi = false;

  @override
  void initState() {
    super.initState();
    cek();
  }

  cek() async {
    var prefs = await SharedPreferences.getInstance();
    var level = prefs.getString("user_level");
    if (level == "supervisi") {
      setState(() {
        supervisi = true;
      });
    } else {
      setState(() {
        supervisi = false;
      });
    }
  }

  int _bottomNavCurrentIndex = 0;
  late List<Widget> _container;

  @override
  Widget build(BuildContext context) {
    _container = [
      const Beranda(),
      const Pekerjaan(),
      if (supervisi) const Verifikasi(),
      const RekapPoint(),
      const Pengaturan(),
    ];

    return Scaffold(
      body: _container[_bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        selectedItemColor: GlobalColors.mainColor,
        iconSize: 20,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomNavCurrentIndex = index;
          });
        },
        currentIndex: _bottomNavCurrentIndex,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Beranda", tooltip: "Beranda"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: "Pekerjaan",
              tooltip: "Pekerjaan"),
          if (supervisi)
            const BottomNavigationBarItem(
                icon: Icon(Icons.verified_user),
                label: "Verifikasi",
                tooltip: "Verifikasi"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Point",
              tooltip: "Point"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Pengaturan",
              tooltip: "Pengaturan"),
        ],
      ),
    );
  }
}
