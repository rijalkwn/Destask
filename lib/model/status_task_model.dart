class StatusTaskModel {
  String? id_status_task;
  String? nama_status_task;
  String? deskripsi_status_task;

  StatusTaskModel({
    this.id_status_task,
    this.nama_status_task,
    this.deskripsi_status_task,
  });

  factory StatusTaskModel.fromJson(Map<String, dynamic> json) {
    return StatusTaskModel(
      id_status_task: json['id_status_task']?.toString(),
      nama_status_task: json['nama_status_task']?.toString(),
      deskripsi_status_task: json['deskripsi_status_task']?.toString(),
    );
  }
}
