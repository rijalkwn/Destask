class PekerjaanModel {
  String? id_pekerjaan;
  String? id_status_pekerjaan;
  String? id_kategori_pekerjaan;
  String? id_personil;
  String? nama_pekerjaan;
  String? pelanggan;
  String? jenis_layanan;
  String? nominal_harga;
  String? deskripsi_pekerjaan;
  DateTime? target_waktu_selesai;
  String? persentase_selesai;
  DateTime? waktu_selesai;
  DataTambahan data_tambahan;

  PekerjaanModel({
    this.id_pekerjaan,
    this.id_status_pekerjaan,
    this.id_kategori_pekerjaan,
    this.id_personil,
    this.nama_pekerjaan,
    this.pelanggan,
    this.jenis_layanan,
    this.nominal_harga,
    this.deskripsi_pekerjaan,
    this.target_waktu_selesai,
    this.persentase_selesai,
    this.waktu_selesai,
    required this.data_tambahan,
  });

  factory PekerjaanModel.fromJson(Map<String, dynamic> json) {
    return PekerjaanModel(
      id_pekerjaan: json['id_pekerjaan']?.toString(),
      id_status_pekerjaan: json['id_status_pekerjaan']?.toString(),
      id_kategori_pekerjaan: json['id_kategori_pekerjaan']?.toString(),
      id_personil: json['id_personil']?.toString(),
      nama_pekerjaan: json['nama_pekerjaan']?.toString(),
      pelanggan: json['pelanggan']?.toString(),
      jenis_layanan: json['jenis_layanan']?.toString(),
      nominal_harga: json['nominal_harga']?.toString(),
      deskripsi_pekerjaan: json['deskripsi_pekerjaan']?.toString(),
      target_waktu_selesai: json['target_waktu_selesai'] == null
          ? null
          : DateTime.parse(json['target_waktu_selesai']),
      persentase_selesai: json['persentase_selesai'] == null
          ? null
          : json['persentase_selesai'].toString(),
      waktu_selesai: json['waktu_selesai'] == null
          ? null
          : DateTime.parse(json['waktu_selesai']),
      data_tambahan: DataTambahan.fromJson(json['data_tambahan']),
    );
  }
}

class DataTambahan {
  String nama_status;
  String nama_kategori;
  String id_user_pm;
  String nama_pm;
  String desainer1;
  String nama_desainer1;
  String desainer2;
  String nama_desainer2;
  String be_web1;
  String nama_be_web1;
  String be_web2;
  String nama_be_web2;
  String be_web3;
  String nama_be_web3;
  String be_mobile1;
  String nama_be_mobile1;
  String be_mobile2;
  String nama_be_mobile2;
  String be_mobile3;
  String nama_be_mobile3;
  String fe_web1;
  String nama_fe_web1;
  String fe_mobile1;
  String nama_fe_mobile1;

  DataTambahan({
    required this.nama_status,
    required this.nama_kategori,
    required this.id_user_pm,
    required this.nama_pm,
    required this.desainer1,
    required this.nama_desainer1,
    required this.desainer2,
    required this.nama_desainer2,
    required this.be_web1,
    required this.nama_be_web1,
    required this.be_web2,
    required this.nama_be_web2,
    required this.be_web3,
    required this.nama_be_web3,
    required this.be_mobile1,
    required this.nama_be_mobile1,
    required this.be_mobile2,
    required this.nama_be_mobile2,
    required this.be_mobile3,
    required this.nama_be_mobile3,
    required this.fe_web1,
    required this.nama_fe_web1,
    required this.fe_mobile1,
    required this.nama_fe_mobile1,
  });

  factory DataTambahan.fromJson(Map<String, dynamic> json) {
    return DataTambahan(
      nama_status: json['nama_status']?.toString() ?? '',
      nama_kategori: json['nama_kategori']?.toString() ?? '',
      id_user_pm: json['id_user_pm']?.toString() ?? '',
      nama_pm: json['nama_pm']?.toString() ?? '',
      desainer1: json['desainer1']?.toString() ?? '',
      nama_desainer1: json['nama_desainer1']?.toString() ?? '',
      desainer2: json['desainer2']?.toString() ?? '',
      nama_desainer2: json['nama_desainer2']?.toString() ?? '',
      be_web1: json['be_web1']?.toString() ?? '',
      nama_be_web1: json['nama_be_web1']?.toString() ?? '',
      be_web2: json['be_web2']?.toString() ?? '',
      nama_be_web2: json['nama_be_web2']?.toString() ?? '',
      be_web3: json['be_web3']?.toString() ?? '',
      nama_be_web3: json['nama_be_web3']?.toString() ?? '',
      be_mobile1: json['be_mobile1']?.toString() ?? '',
      nama_be_mobile1: json['nama_be_mobile1']?.toString() ?? '',
      be_mobile2: json['be_mobile2']?.toString() ?? '',
      nama_be_mobile2: json['nama_be_mobile2']?.toString() ?? '',
      be_mobile3: json['be_mobile3']?.toString() ?? '',
      nama_be_mobile3: json['nama_be_mobile3']?.toString() ?? '',
      fe_web1: json['fe_web1']?.toString() ?? '',
      nama_fe_web1: json['nama_fe_web1']?.toString() ?? '',
      fe_mobile1: json['fe_mobile1']?.toString() ?? '',
      nama_fe_mobile1: json['nama_fe_mobile1']?.toString() ?? '',
    );
  }
}
