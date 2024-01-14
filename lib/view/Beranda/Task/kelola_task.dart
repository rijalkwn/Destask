import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';

class KelolaTask extends StatefulWidget {
  @override
  _KelolaTaskState createState() => _KelolaTaskState();
}

class _KelolaTaskState extends State<KelolaTask> {
  List<String> kategoriPenugasan = ['Pilihan 1', 'Pilihan 2', 'Pilihan 3'];
  List<String> statusProses = ['Proses 1', 'Proses 2', 'Proses 3'];

  TextEditingController _modulTaskController = TextEditingController();
  String _selectedKategoriPenugasan = 'Pilihan 1';
  String _selectedStatusProses = 'Proses 1';

  @override
  void dispose() {
    _modulTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GlobalColors.mainColor, // Ubah warna sesuai preferensi Anda
        title: const Text('Nama Pekerjaan',
            style: TextStyle(
                color: Colors.white)), // Ubah warna teks sesuai kebutuhan
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildLabel('Nama Pelanggan'),
            buildReadOnlyField('Nama Pelanggan', 'John Doe'),
            buildLabel('Layanan'),
            buildReadOnlyField('Layanan', 'Service A'),
            buildLabel('Telepon'),
            buildReadOnlyField('Telepon', '123-456-789'),
            buildLabel('PIC'),
            buildReadOnlyField('PIC', 'Jane Smith'),
            buildLabel('Email'),
            buildReadOnlyField('Email', 'john.doe@example.com'),
            SizedBox(height: 10),
            buildLabel('Modul/Task'),
            TextFormField(
              controller: _modulTaskController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            buildLabel('Kategori Penugasan'),
            buildDropdownField(
              kategoriPenugasan,
              _selectedKategoriPenugasan,
              (newValue) {
                setState(() {
                  _selectedKategoriPenugasan = newValue.toString();
                });
              },
            ),
            SizedBox(height: 20),
            buildLabel('Status Proses'),
            buildDropdownField(
              statusProses,
              _selectedStatusProses,
              (newValue) {
                setState(() {
                  _selectedStatusProses = newValue.toString();
                });
              },
            ),
            SizedBox(height: 20),
            buildLabel('Unggah File / Tambah Link / Progres'),
            TextFormField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            //tombol simpan
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                // margin: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue, // Ganti warna sesuai kebutuhan
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownField(
    List<String> items,
    String selectedValue,
    Function onChanged,
  ) {
    return DropdownButtonFormField(
      value: selectedValue,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (newValue) {
        onChanged(newValue);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
      ),
    );
  }
}

Widget buildReadOnlyField(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: InputDecorator(
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      child: Text(
        value,
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}

Widget buildLabel(String text) {
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
