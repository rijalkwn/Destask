import 'package:destask/view/Beranda/Informasi/pekerjaan_selesai.dart';
import 'package:destask/view/Beranda/Task/detail_task.dart';
import 'package:destask/view/Beranda/Task/add_task.dart';
import 'package:destask/view/Beranda/Task/edit_task.dart';
import 'package:destask/view/Beranda/Task/task.dart';
import 'package:destask/view/Beranda/beranda.dart';
import 'package:destask/view/KPI/KPI.dart';
import 'package:destask/view/Menu/bottom_nav.dart';
import 'package:destask/view/Notifikasi/notifikasi.dart';
import 'package:destask/view/Pekerjaan/detail_pekerjaan.dart';
import 'package:destask/view/Pekerjaan/pekerjaan.dart';
import 'package:destask/view/Pengaturan/pengaturan.dart';
import 'package:destask/view/Pengaturan/edit_profile.dart';
import 'package:destask/view/Auth/ganti_password.dart';
import 'package:destask/view/Auth/login.dart';
import 'package:destask/view/Auth/lupa_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/route_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const BottomNav()),
          GetPage(name: '/bottomnav', page: () => const BottomNav()),
          GetPage(name: '/login', page: () => const Login()),
          GetPage(name: '/lupa_password', page: () => const LupaPassword()),
          GetPage(name: '/beranda', page: () => Beranda()),
          GetPage(name: '/pekerjaan_selesai', page: () => PekerjaanSelesai()),
          GetPage(name: '/target_bulan_ini', page: () => PekerjaanSelesai()),
          GetPage(name: '/task_selesai', page: () => PekerjaanSelesai()),
          GetPage(name: '/notifikasi', page: () => const Notifikasi()),
          GetPage(
            name: '/task/:idpekerjaan',
            page: () => Task(),
          ),
          GetPage(name: '/add_task/:idpekerjaan', page: () => AddTask()),
          GetPage(name: '/edit_task/:idtask', page: () => EditTask()),
          GetPage(name: '/delete_task/:idtask', page: () => EditTask()),
          GetPage(name: '/detail_task', page: () => DetailTask()),
          GetPage(name: '/pekerjaan', page: () => const Pekerjaan()),
          // GetPage(
          //     name: '/detail_pekerjaan/:idpekerjaan',
          //     page: () => const DetailPekerjaan()),
          GetPage(name: '/kpi', page: () => KPI()),
          GetPage(name: '/pengaturan', page: () => Pengaturan()),
          GetPage(name: '/edit_profile/:id_user', page: () => EditProfile()),
          GetPage(name: '/ganti_password', page: () => const GantiPassword()),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
        home: const BottomNav());
  }
}
