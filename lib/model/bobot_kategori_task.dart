class BobotKategoriTaskModel {
  final String? id_bobot_kategori_task;
  final String? id_kategori_task;
  final String? id_usergroup;
  final String? tahun;
  final String? bobot_poin;

  BobotKategoriTaskModel({
    this.id_bobot_kategori_task,
    this.id_kategori_task,
    this.id_usergroup,
    this.tahun,
    this.bobot_poin,
  });

  factory BobotKategoriTaskModel.fromJson(Map<String, dynamic> json) {
    return BobotKategoriTaskModel(
      id_bobot_kategori_task: json['id_bobot_kategori_task'],
      id_kategori_task: json['id_kategori_task'],
      id_usergroup: json['id_usergroup'],
      tahun: json['tahun'],
      bobot_poin: json['bobot_poin'],
    );
  }
}
