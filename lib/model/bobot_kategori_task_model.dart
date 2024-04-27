class BobotKategoriTaskModel {
  String id_bobot_kategori_task;
  String id_kategori_task;
  String id_usergroup;
  String tahun;
  String bobot_poin;

  BobotKategoriTaskModel(
      {required this.id_bobot_kategori_task,
      required this.id_kategori_task,
      required this.id_usergroup,
      required this.tahun,
      required this.bobot_poin});

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
