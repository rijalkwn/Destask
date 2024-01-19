class TaskModel {
  final String? idtask;
  final String? nama_task;
  final String? detail_task;
  final String? tanggal_mulai;
  final String? tanggal_selesai;

  TaskModel({
    this.idtask,
    this.nama_task,
    this.detail_task,
    this.tanggal_mulai,
    this.tanggal_selesai,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      idtask: json['idtask'],
      nama_task: json['nama_task'],
      detail_task: json['detail_task'],
      tanggal_mulai: json['tanggal_mulai'],
      tanggal_selesai: json['tanggal_selesai'],
    );
  }
}
