import 'package:destask/model/pekerjaan_model.dart';
import 'package:destask/utils/constant_api.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// API link
const pURL = '${baseURL}/api/pekerjaan';

class PekerjaanController {
  Future<List<dynamic>> getAllPekerjaan() async {
    try {
      var response = await http.get(Uri.parse(pURL));
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

  Future<List<dynamic>> getOnProgress() async {
    try {
      var response = await http.get(Uri.parse(pURL));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        List<dynamic> pekerjaan = List<dynamic>.from(list
            .where((element) => element['status'] == "On Progress")
            .map((e) => PekerjaanModel.fromJson(e)));
        return pekerjaan;
      } else {
        Get.snackbar(
          "Error",
          "Gagal mengambil data pekerjaan",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Returning an empty list in case of an error
        return [];
      }
    } catch (e) {
      print(e);
      // Returning an empty list in case of an exception
      return [];
    }
  }
}
