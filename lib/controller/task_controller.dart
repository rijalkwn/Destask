import '../model/task_model.dart';
import '../utils/constant_api.dart';
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

Future getIdUser() async {
  final prefs = await SharedPreferences.getInstance();
  var idUser = prefs.getString("id_user");
  return idUser;
}

class TaskController {
  //fungsi mendapatkan semua task
  Future getAllTask() async {
    var token = await getToken();
    var response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<TaskModel> task =
          List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
      return task;
    } else {
      // Handle error
      return [];
    }
  }

  //fungsi menampilkan semua task
  Future<List<TaskModel>> showAll() async {
    List<TaskModel> data = await getAllTask();
    return data;
  }

  //fungsi mendapatkan task berdasarkan id
  Future<List<TaskModel>> getTaskById(String idTask) async {
    try {
      var token = await getToken();
      var response = await http.get(Uri.parse('$url/$idTask'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TaskModel> user =
            List<TaskModel>.from(it.map((e) => TaskModel.fromJson(e)).toList());
        return user;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //fungsi menampilkan task berdasarkan id
  Future<List<TaskModel>> showById(String idTask) async {
    List<TaskModel> data = await getTaskById(idTask);
    return data;
  }

  //boolean cek apakah task ada di tanggal yang dipilih
  bool isTaskOnSelectedDate(Map<String, dynamic> task, DateTime selectedDate) {
    DateTime createdTask = DateTime.parse(task['created_at']);
    DateTime? taskSelesai = task['tgl_selesai'] != null
        ? DateTime.parse(task['tgl_selesai'])
        : null;
    return selectedDate.isAfter(createdTask.subtract(Duration(days: 1))) &&
        (taskSelesai == null ||
            selectedDate.isBefore(taskSelesai.add(Duration(days: 1))));
  }

  //fungsi mendapatkan task berdasarkan id pekerjaan dan tanggal
  Future<List<TaskModel>> getTasksByPekerjaanId(
      String idPekerjaan, DateTime selectedDate) async {
    const urlx = '$baseURL/api/taskbypekerjaan';
    var token = await getToken();
    var response = await http.get(Uri.parse('$urlx/$idPekerjaan'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<TaskModel> task = List<TaskModel>.from(it
          .where((element) => isTaskOnSelectedDate(element, selectedDate))
          .map((e) => TaskModel.fromJson(e))
          .toList());
      return task;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  //fungsi menampilkan task berdasarkan id pekerjaan
  Future<List<TaskModel>> showByPekerjaanId(
      String idPekerjaan, DateTime selectedDate) async {
    List<TaskModel> data =
        await getTasksByPekerjaanId(idPekerjaan, selectedDate);
    return data;
  }

  //fungsi mendapatkan task berdasarkan id user dan id pekerjaan dan tanggal
  Future<List<TaskModel>> getTasksByUserPekerjaanDate(
      String idPekerjaan, DateTime selectedDate) async {
    try {
      const urlx = '$baseURL/api/taskbyuser';
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.get(Uri.parse('$urlx/$idUser'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TaskModel> tasks = List<TaskModel>.from(it
            .where((element) =>
                element['id_pekerjaan'] == idPekerjaan &&
                isTaskOnSelectedDate(element, selectedDate))
            .map((e) => TaskModel.fromJson(e))
            .toList());
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

  //fungsi menampilkan task berdasarkan id user dan id pekerjaan dan tanggal
  Future<List<TaskModel>> showByUserPekerjaanDate(
      String idPekerjaan, DateTime selectedDate) async {
    List<TaskModel> data =
        await getTasksByUserPekerjaanDate(idPekerjaan, selectedDate);
    return data;
  }

  //fungsi mendapatkan task berdasarkan id user dan id pekerjaan
  Future<List<TaskModel>> getTasksByUserPekerjaan(String idPekerjaan) async {
    try {
      const urlx = '$baseURL/api/taskbyuser';
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.get(Uri.parse('$urlx/$idUser'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable it = json.decode(response.body);
        List<TaskModel> tasks = List<TaskModel>.from(it
            .where((element) => element['id_pekerjaan'] == idPekerjaan)
            .map((e) => TaskModel.fromJson(e))
            .toList());
        return tasks;
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //fungsi menampilkan task berdasarkan id user dan id pekerjaan
  Future<List<TaskModel>> showByUserPekerjaan(String idPekerjaan) async {
    List<TaskModel> data = await getTasksByUserPekerjaan(idPekerjaan);
    return data;
  }

  //fungsi add task
  Future addTask(
    String idPekerjaan,
    String idStatusTask,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String tautanTask,
  ) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id_pekerjaan': idPekerjaan,
          'id_user': idUser,
          'id_status_task': idStatusTask,
          'id_kategori_task': idKategoriTask,
          'tgl_planing':
              tglPlaning.toIso8601String(), // Convert DateTime to string
          'deskripsi_task': deskripsiTask,
          'tautan_task': tautanTask,
        },
      );

      if (response.statusCode == 200) {
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

  //fungsi edit task
  Future editTask(
    String idTask,
    String idPekerjaan,
    String idStatusTask,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String tautanTask,
    String persentaseSelesai,
  ) async {
    try {
      var token = await getToken();
      var idUser = await getIdUser();
      var formattedDate =
          "${tglPlaning.year}-${tglPlaning.month.toString().padLeft(2, '0')}-${tglPlaning.day.toString().padLeft(2, '0')}";
      final data = {
        "id_task": idTask.toString(),
        "id_pekerjaan": idPekerjaan.toString(),
        "id_user": idUser.toString(),
        "id_status_task": idStatusTask.toString(),
        "id_kategori_task": idKategoriTask.toString(),
        "tgl_planing": formattedDate,
        "persentase_selesai": persentaseSelesai.toString(),
        "deskripsi_task": deskripsiTask.toString(),
        "tautan_task": tautanTask.toString()
      };
      print(jsonEncode(data));
      var response = await http.put(
        Uri.parse('$url/$idTask'),
        headers: {
          'Content-Type': 'application/json', // Add Content-Type header
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
        Get.offAndToNamed('/task/$idPekerjaan');
        return true;
      } else {
        print('$url/$idTask');
        print('Error editing task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception editing task: $e');
      return false;
    }
  }

  //delete task
  Future deleteTask(
    String idTask,
  ) async {
    try {
      var token = await getToken();
      var response = await http.delete(Uri.parse('$url/$idTask'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        print(response.body);
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
