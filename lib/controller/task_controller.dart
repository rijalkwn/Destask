import 'package:destask/utils/constant_api.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// API link
const URL = '${baseURL}/api/task';

class TaskController {
  Future<List<dynamic>> getAllTask() async {
    try {
      var response = await http.get(Uri.parse(URL));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        List<dynamic> pekerjaan = List<dynamic>.from(list.map((e) => e));
        return pekerjaan;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      // Handle exception
      return [];
    }
  }

  Future<List<dynamic>> getTasksByPekerjaanId(String idPekerjaan) async {
    try {
      var response = await http.get(Uri.parse('$URL?idpekerjaan=$idPekerjaan'));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        List<dynamic> tasks = List<dynamic>.from(list.map((e) => e));
        return tasks;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      // Handle exception
      return [];
    }
  }

  //fungsi add task
  Future<bool> addTask(
    String idPekerjaan,
    String taskName,
    String taskDetail,
    DateTime tanggalMulai,
    DateTime tanggalSelesai,
  ) async {
    try {
      var response = await http.post(
        Uri.parse(URL),
        body: {
          'idpekerjaan': '1',
          'nama_task': taskName,
          'detail_task': taskDetail,
          'tanggal_mulai': tanggalMulai.toString(),
          'tanggal_selesai': tanggalSelesai.toString(),
        },
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          "Berhasil",
          "Berhasil menambahkan task",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        print('Error adding task: ${response.body}');
        Get.snackbar(
          "Error",
          "Gagal menambahkan task",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Exception adding task: $e');
      return false;
    }
  }
}
