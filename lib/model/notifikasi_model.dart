class NotifikasiModel {
  final String? id_notifikasi;
  final String? id_user;
  final String? id_task;
  final String? id_pekerjaan;
  final String? id_kinerja;
  final String? judul_notifikasi;
  final String? pesan_notifikasi;
  final String? status_terbaca;
  final String? created_at;

  NotifikasiModel({
    this.id_notifikasi,
    this.id_user,
    this.id_task,
    this.id_pekerjaan,
    this.id_kinerja,
    this.judul_notifikasi,
    this.pesan_notifikasi,
    this.status_terbaca,
    this.created_at,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id_notifikasi: json['id_notifikasi'],
      id_user: json['id_user'],
      id_task: json['id_task'],
      id_pekerjaan: json['id_pekerjaan'],
      id_kinerja: json['id_kinerja'],
      judul_notifikasi: json['judul_notifikasi'],
      pesan_notifikasi: json['pesan_notifikasi'],
      status_terbaca: json['status_terbaca'],
      created_at: json['created_at'],
    );
  }
}
