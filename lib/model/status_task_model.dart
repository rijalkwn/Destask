class StatusTaskModel {
  String id_status_task;
  String nama_status_task;
  String deskripsi_status_task;
  String color;

  StatusTaskModel({
    required this.id_status_task,
    required this.nama_status_task,
    required this.deskripsi_status_task,
    required this.color,
  });

  factory StatusTaskModel.fromJson(Map<String, dynamic> json) {
    return StatusTaskModel(
      id_status_task: json['id_status_task'],
      nama_status_task: json['nama_status_task'],
      deskripsi_status_task: json['deskripsi_status_task'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_status_task': id_status_task,
      'nama_status_task': nama_status_task,
      'deskripsi_status_task': deskripsi_status_task,
      'color': color,
    };
  }
}
