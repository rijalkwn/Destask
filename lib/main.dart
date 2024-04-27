import 'package:destask/view/verifikasi/detail_verifikasi.dart';
import 'package:destask/view/verifikasi/verifikasi.dart';

import '../view/Beranda/Informasi/pekerjaan_selesai.dart';
import '../view/Beranda/Task/detail_task.dart';
import '../view/Beranda/Task/add_task.dart';
import '../view/Beranda/Task/edit_task.dart';
import '../view/Beranda/Task/task.dart';
import '../view/Beranda/beranda.dart';
import '../view/RekapPoint/rekap_point.dart';
import '../view/Menu/bottom_nav.dart';
import '../view/Notifikasi/notifikasi.dart';
import '../view/Pekerjaan/detail_pekerjaan.dart';
import '../view/Pekerjaan/pekerjaan.dart';
import '../view/Pengaturan/pengaturan.dart';
import '../view/Pengaturan/edit_profile.dart';
import '../view/Auth/ganti_password.dart';
import '../view/Auth/login.dart';
import '../view/Auth/lupa_password.dart';
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
          GetPage(name: '/bottom_nav', page: () => const BottomNav()),
          GetPage(name: '/login', page: () => const Login()),
          GetPage(name: '/lupa_password', page: () => const LupaPassword()),
          GetPage(name: '/beranda', page: () => const Beranda()),
          GetPage(
              name: '/pekerjaan_selesai', page: () => const PekerjaanSelesai()),
          GetPage(name: '/task_selesai', page: () => const PekerjaanSelesai()),
          GetPage(name: '/notifikasi', page: () => const Notifikasi()),
          GetPage(
            name: '/task/:idpekerjaan',
            page: () => const Task(),
          ),
          GetPage(name: '/add_task/:idpekerjaan', page: () => const AddTask()),
          GetPage(name: '/edit_task/:idtask', page: () => const EditTask()),
          GetPage(name: '/detail_task/:idtask', page: () => const DetailTask()),
          GetPage(name: '/pekerjaan', page: () => const Pekerjaan()),
          GetPage(
              name: '/detail_pekerjaan/:idpekerjaan',
              page: () => const DetailPekerjaan()),
          GetPage(name: '/rekap_point', page: () => const RekapPoint()),
          GetPage(name: '/verifikasi', page: () => const Verifikasi()),
          GetPage(
              name: '/detail_verifikasi/:idtask',
              page: () => const DetailVerifikasi()),
          GetPage(name: '/pengaturan', page: () => const Pengaturan()),
          GetPage(name: '/edit_profile/:id_user', page: () => EditProfile()),
          GetPage(name: '/ganti_password', page: () => const GantiPassword()),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
        home: const Login());
  }
}
