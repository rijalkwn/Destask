class StatusTaskModel {
  String id_status_task;
  String nama_status_task;
  String deskripsi_status_task;

  StatusTaskModel({
    required this.id_status_task,
    required this.nama_status_task,
    required this.deskripsi_status_task,
  });

  factory StatusTaskModel.fromJson(Map<String, dynamic> json) {
    return StatusTaskModel(
      id_status_task: json['id_status_task'],
      nama_status_task: json['nama_status_task'],
      deskripsi_status_task: json['deskripsi_status_task'],
    );
  }
}
