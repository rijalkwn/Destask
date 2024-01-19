import 'package:destask/model/pekerjaan_model.dart';
import 'package:destask/utils/constant_api.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// API link
const pURL = '${baseURL}/api/task';

class TaskController {
  Future<List<dynamic>> getAllTask() async {
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

  Future<List<dynamic>> getTasksByPekerjaanId(String idpekerjaan) async {
    try {
      var response =
          await http.get(Uri.parse('$pURL?pekerjaan_id=$idpekerjaan'));
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
}
