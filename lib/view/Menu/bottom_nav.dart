// File: bottom_nav.dart
import 'package:destask/utils/global_colors.dart';
import 'package:destask/view/Beranda/beranda.dart';
import 'package:destask/view/KPI/KPI.dart';
import 'package:destask/view/Pekerjaan/pekerjaan.dart';
import 'package:destask/view/Pengaturan/pengaturan.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = [
    Beranda(),
    Pekerjaan(),
    KPI(),
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
        iconSize: 24,
        selectedFontSize: 18,
        unselectedFontSize: 16,
        unselectedItemColor: Colors.lightBlue[300],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomNavCurrentIndex = index;
          });
        },
        currentIndex: _bottomNavCurrentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: "Pekerjaan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "KPI"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Pengaturan"),
        ],
      ),
    );
  }
}
