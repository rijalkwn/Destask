import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailTask extends StatefulWidget {
  DetailTask({super.key});

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GlobalColors.mainColor, // Ubah warna sesuai preferensi Anda
        title: const Text('Nama Task',
            style: TextStyle(
                color: Colors.white)), // Ubah warna teks sesuai kebutuhan
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextLabel("Nama Pelanggan"),
            TextForm('Nama Pelanggan'),
            SizedBox(height: 10),
            TextLabel("Layanan"),
            TextForm('Layanan'),
            SizedBox(height: 10),
            TextLabel("Telepon"),
            TextForm('Telepon'),
            SizedBox(height: 10),
            TextLabel("PIC"),
            TextForm('PIC'),
            SizedBox(height: 10),
            //simpan
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: GlobalColors.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding TextLabel(String text) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextFormField TextForm(String label) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
        hintText: label,
      ),
    );
  }
}
