class TaskModel {
  final String? id_task;
  final String? id_pekerjaan;
  final String? id_user;
  final String? id_status_task;
  final String? id_kategori_task;
  final String? tgl_planing;
  final String? tgl_selesai;
  final String? tgl_verifikasi_diterima;
  final String? status_verifikasi;
  final String? persentase_selesai;
  final String? deskripsi_task;
  final String? alasan_verifikasi;
  final String? bukti_selesai;
  final String? tautan_task;
  final String? created_at;

  TaskModel({
    this.id_task,
    this.id_pekerjaan,
    this.id_user,
    this.id_status_task,
    this.id_kategori_task,
    this.tgl_planing,
    this.tgl_selesai,
    this.tgl_verifikasi_diterima,
    this.status_verifikasi,
    this.persentase_selesai,
    this.deskripsi_task,
    this.alasan_verifikasi,
    this.bukti_selesai,
    this.tautan_task,
    this.created_at,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id_task: json['id_task'],
      id_pekerjaan: json['id_pekerjaan'],
      id_user: json['id_user'],
      id_status_task: json['id_status_task'],
      id_kategori_task: json['id_kategori_task'],
      tgl_planing: json['tgl_planing'] ?? '',
      tgl_selesai: json['tgl_selesai'] ?? '',
      tgl_verifikasi_diterima: json['tgl_verifikasi_diterima'] ?? '',
      status_verifikasi: json['status_verifikasi'] ?? '',
      persentase_selesai: json['persentase_selesai'],
      deskripsi_task: json['deskripsi_task'],
      alasan_verifikasi: json['alasan_verifikasi'] ?? '',
      bukti_selesai: json['bukti_selesai'] ?? '',
      tautan_task: json['tautan_task'] ?? '',
      created_at: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_task': id_task,
      'id_pekerjaan': id_pekerjaan,
      'id_user': id_user,
      'id_status_task': id_status_task,
      'id_kategori_task': id_kategori_task,
      'tgl_planing': tgl_planing,
      'tgl_selesai': tgl_selesai,
      'tgl_verifikasi_diterima': tgl_verifikasi_diterima,
      'status_verifikasi': status_verifikasi,
      'persentase_selesai': persentase_selesai,
      'deskripsi_task': deskripsi_task,
      'alasan_verifikasi': alasan_verifikasi,
      'bukti_selesai': bukti_selesai,
      'tautan_task': tautan_task,
      'created_at': created_at,
    };
  }
}
