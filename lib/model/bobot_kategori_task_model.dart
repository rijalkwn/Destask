class BobotKategoriTaskModel {
  String? id_bobot_kategori_task;
  String? id_kategori_task;
  String? id_usergroup;
  String? tahun;
  String? bobot_poin;

  BobotKategoriTaskModel({
    this.id_bobot_kategori_task,
    this.id_kategori_task,
    this.id_usergroup,
    this.tahun,
    this.bobot_poin,
  });

  factory BobotKategoriTaskModel.fromJson(Map<String, dynamic> json) {
    return BobotKategoriTaskModel(
      id_bobot_kategori_task: json['id_bobot_kategori_task']?.toString(),
      id_kategori_task: json['id_kategori_task']?.toString(),
      id_usergroup: json['id_usergroup']?.toString(),
      tahun: json['tahun']?.toString(),
      bobot_poin: json['bobot_poin']?.toString(),
    );
  }
}
