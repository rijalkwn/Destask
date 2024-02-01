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
  Future getAllTask() async {
    try {
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
    } catch (e) {
      // Handle exception
      return [];
    }
  }

  //get task by id
  Future getTaskById(String idTask) async {
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
        // Handle error
        return {};
      }
    } catch (e) {
      // Handle exception
      return {};
    }
  }

  bool isTaskOnSelectedDate(Map<String, dynamic> task, DateTime selectedDate) {
    DateTime createdTask = DateTime.parse(task['created_at']);
    DateTime? taskSelesai = task['tgl_selesai'] != null
        ? DateTime.parse(task['tgl_selesai'])
        : null;
    return selectedDate.isAfter(createdTask.subtract(Duration(days: 1))) &&
        (taskSelesai == null ||
            selectedDate.isBefore(taskSelesai.add(Duration(days: 1))));
  }

  //get task by pekerjaan
  Future getTasksByPekerjaanId(
      String idPekerjaan, DateTime selectedDate) async {
    try {
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
    } catch (e) {
      print(e);
      return [];
    }
  }

  //get task by user dan pekerjaan
  Future getTasksByUserPekerjaanDate(
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

  Future getTasksByUserPekerjaan(String idPekerjaan) async {
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

  //fungsi add task
  Future addTask(
    String idPekerjaan,
    String idUser,
    String idStatusTask,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String tautanTask,
  ) async {
    try {
      var token = await getToken();
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

  Future editTask(
    String idTask,
    String idPekerjaan,
    String idUser,
    String idStatusTask,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String tautanTask,
    String persentaseSelesai,
  ) async {
    try {
      var token = await getToken();
      var response = await http.put(
        Uri.parse('$url/$idTask'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id_task': idTask,
          'id_pekerjaan': idPekerjaan,
          'id_user': idUser,
          'id_status_task': idStatusTask,
          'id_kategori_task': idKategoriTask,
          'tgl_planing': tglPlaning,
          'deskripsi_task': deskripsiTask,
          'tautan_task': tautanTask,
          'persentase_selesai': persentaseSelesai,
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

  //submit task
  Future submitTask(
    String idTask,
    String idPekerjaan,
    String idUser,
    String idStatusTask,
    String idKategoriTask,
    DateTime tglPlaning,
    String deskripsiTask,
    String tautanTask,
    String persentaseSelesai,
    String buktiSelesai,
  ) async {
    try {
      var token = await getToken();
      var response = await http.put(
        Uri.parse('$url/$idTask'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id_task': idTask,
          'id_pekerjaan': idPekerjaan,
          'id_user': idUser,
          'id_status_task': idStatusTask,
          'id_kategori_task': idKategoriTask,
          'tgl_planing': tglPlaning.toIso8601String(),
          'deskripsi_task': deskripsiTask,
          'tautan_task': tautanTask,
          'persentase_selesai': persentaseSelesai,
          'bukti_selesai': buktiSelesai,
        },
      );

      if (response.statusCode == 200) {
        Get.offAndToNamed('/task/$idPekerjaan');
        return true;
      } else {
        print('Error submitting task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception submitting task: $e');
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
