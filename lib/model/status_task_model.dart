class StatusTaskModel {
  final String? id_status_task;
  final String? nama_status_task;
  final String? deskripsi_status_task;

  StatusTaskModel({
    this.id_status_task,
    this.nama_status_task,
    this.deskripsi_status_task,
  });

  factory StatusTaskModel.fromJson(Map<String, dynamic> json) {
    return StatusTaskModel(
      id_status_task: json['id_status_task'],
      nama_status_task: json['nama_status_task'],
      deskripsi_status_task: json['deskripsi_status_task'],
    );
  }
}
