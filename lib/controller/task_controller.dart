import 'package:destask/utils/constant_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// API link
const url = '$baseURL/api/task';

Future getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  return token;
}

class TaskController {
  Future<List<dynamic>> getAllTask() async {
    try {
      var token = await getToken();
      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
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

  //get task by id
  Future<Map<String, dynamic>> getTaskById(String idTask) async {
    try {
      var token = await getToken();
      var response = await http.get(Uri.parse('$url/$idTask'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Map<String, dynamic> task = json.decode(response.body);
        return task;
      } else {
        // Handle error
        return {};
      }
    } catch (e) {
      // Handle exception
      return {};
    }
  }

  Future<List<dynamic>> getTasksByPekerjaanId(String idPekerjaan) async {
    try {
      var token = await getToken();
      var response = await http.get(Uri.parse('$url?idpekerjaan=$idPekerjaan'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        List<dynamic> tasks = List<dynamic>.from(list.map((e) => e));
        return tasks;
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  //fungsi add task
  Future addTask(
    String idPekerjaan,
    String taskName,
    String taskDetail,
    DateTime tanggalMulai,
    DateTime tanggalSelesai,
  ) async {
    try {
      var token = await getToken();
      var response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'idpekerjaan': idPekerjaan,
          'nama_task': taskName,
          'detail_task': taskDetail,
          'tanggal_mulai': tanggalMulai.toString(),
          'tanggal_selesai': tanggalSelesai.toString(),
        },
      );

      if (response.statusCode == 201) {
        Get.toNamed('/task/$idPekerjaan');
        return true;
      } else {
        print('Error adding task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception adding task: $e');
      return false;
    }
  }

  Future editTask(
    String idPekerjaan,
    String idTask,
    String taskName,
    String taskDetail,
    DateTime tanggalMulai,
    DateTime tanggalSelesai,
  ) async {
    try {
      var token = await getToken();
      var response = await http.put(
        Uri.parse('$url/$idTask'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'nama_task': taskName,
          'detail_task': taskDetail,
          'tanggal_mulai': tanggalMulai.toString(),
          'tanggal_selesai': tanggalSelesai.toString(),
        },
      );

      if (response.statusCode == 200) {
        Get.offAndToNamed('/task/$idPekerjaan');
        return true;
      } else {
        print('Error editing task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception editing task: $e');
      return false;
    }
  }

  Future deleteTask(
    String idTask,
  ) async {
    try {
      var token = await getToken();
      var response = await http.delete(Uri.parse('$url/$idTask'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error deleting task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception deleting task: $e');
      return false;
    }
  }
}
