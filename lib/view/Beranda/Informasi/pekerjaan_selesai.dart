import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PekerjaanSelesai extends StatelessWidget {
  const PekerjaanSelesai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pekerjaan Selesai'),
      ),
      body: Center(
        child: Text(
          'Tampilkan informasi total pekerjaan di sini',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
