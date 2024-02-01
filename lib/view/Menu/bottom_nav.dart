import 'package:flutter/material.dart';
import '../../utils/global_colors.dart';
import '../../view/Beranda/beranda.dart';
import '../../view/RekapPoint/rekap_point.dart';
import '../../view/Pekerjaan/pekerjaan.dart';
import '../../view/Pengaturan/pengaturan.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = [
    Beranda(),
    Pekerjaan(),
    RekapPoint(),
    Pengaturan(),
  ];

  @override
  Widget build(BuildContext context) {
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
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Beranda", tooltip: "Beranda"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: "Pekerjaan",
              tooltip: "Pekerjaan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Point",
              tooltip: "Point"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Pengaturan",
              tooltip: "Pengaturan"),
        ],
      ),
    );
  }
}
