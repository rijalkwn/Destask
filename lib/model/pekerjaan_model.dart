class PekerjaanModel {
  String id_pekerjaan;
  String id_status_pekerjaan;
  String id_kategori_pekerjaan;
  String nama_pekerjaan;
  String pelanggan;
  String jenis_pelanggan;
  String nama_pic;
  String email_pic;
  String nowa_pic;
  String jenis_layanan;
  String nominal_harga;
  String deskripsi_pekerjaan;
  DateTime target_waktu_selesai;
  String persentase_selesai;
  DateTime? waktu_selesai;
  DataTambahan data_tambahan;

  PekerjaanModel({
    required this.id_pekerjaan,
    required this.id_status_pekerjaan,
    required this.id_kategori_pekerjaan,
    required this.nama_pekerjaan,
    required this.pelanggan,
    required this.jenis_pelanggan,
    required this.nama_pic,
    required this.email_pic,
    required this.nowa_pic,
    required this.jenis_layanan,
    required this.nominal_harga,
    required this.deskripsi_pekerjaan,
    required this.target_waktu_selesai,
    required this.persentase_selesai,
    this.waktu_selesai,
    required this.data_tambahan,
  });

  factory PekerjaanModel.fromJson(Map<String, dynamic> json) {
    return PekerjaanModel(
        id_pekerjaan: json['id_pekerjaan'],
        id_status_pekerjaan: json['id_status_pekerjaan'],
        id_kategori_pekerjaan: json['id_kategori_pekerjaan'],
        nama_pekerjaan: json['nama_pekerjaan'] ?? '',
        pelanggan: json['pelanggan'] ?? '',
        jenis_pelanggan: json['jenis_pelanggan'] ?? '',
        nama_pic: json['nama_pic'] ?? '',
        email_pic: json['email_pic'] ?? '',
        nowa_pic: json['nowa_pic'] ?? '',
        jenis_layanan: json['jenis_layanan'] ?? '',
        nominal_harga: json['nominal_harga'] ?? '',
        deskripsi_pekerjaan: json['deskripsi_pekerjaan'] ?? '',
        target_waktu_selesai: DateTime.parse(json['target_waktu_selesai']),
        persentase_selesai: json['persentase_selesai'] ?? '',
        waktu_selesai: json['waktu_selesai'] != null
            ? DateTime.parse(json['waktu_selesai'])
            : null,
        data_tambahan: DataTambahan.fromJson(json['data_tambahan']));
  }
}

class DataTambahan {
  final String nama_status_pekerjaan;
  final String nama_kategori_pekerjaan;
  final List<PmModel> pm;
  final List<DesainerModel> desainer;
  final List<BackendModel> backend_web;
  final List<BackendModel> backend_mobile;
  final List<FrontendModel> frontend_web;
  final List<FrontendModel> frontend_mobile;

  DataTambahan({
    required this.nama_status_pekerjaan,
    required this.nama_kategori_pekerjaan,
    required this.pm,
    required this.desainer,
    required this.backend_web,
    required this.backend_mobile,
    required this.frontend_web,
    required this.frontend_mobile,
  });

  factory DataTambahan.fromJson(Map<String, dynamic> json) {
    List<PmModel> pmList = [];
    if (json['pm'] != null) {
      json['pm'].forEach((pm) {
        pmList.add(PmModel.fromJson(pm));
      });
    }

    List<DesainerModel> desainerList = [];
    if (json['desainer'] != null) {
      json['desainer'].forEach((desainer) {
        desainerList.add(DesainerModel.fromJson(desainer));
      });
    }

    List<BackendModel> backendWebList = [];
    if (json['backend_web'] != null) {
      json['backend_web'].forEach((backendWeb) {
        backendWebList.add(BackendModel.fromJson(backendWeb));
      });
    }

    List<BackendModel> backendMobileList = [];
    if (json['backend_mobile'] != null) {
      json['backend_mobile'].forEach((backendMobile) {
        backendMobileList.add(BackendModel.fromJson(backendMobile));
      });
    }

    List<FrontendModel> frontendWebList = [];
    if (json['frontend_web'] != null) {
      json['frontend_web'].forEach((frontendWeb) {
        frontendWebList.add(FrontendModel.fromJson(frontendWeb));
      });
    }

    List<FrontendModel> frontendMobileList = [];
    if (json['frontend_mobile'] != null) {
      json['frontend_mobile'].forEach((frontendMobile) {
        frontendMobileList.add(FrontendModel.fromJson(frontendMobile));
      });
    }

    return DataTambahan(
      nama_status_pekerjaan: json['nama_status_pekerjaan'],
      nama_kategori_pekerjaan: json['nama_kategori_pekerjaan'],
      pm: pmList,
      desainer: desainerList,
      backend_web: backendWebList,
      backend_mobile: backendMobileList,
      frontend_web: frontendWebList,
      frontend_mobile: frontendMobileList,
    );
  }
}

class PmModel {
  final String id_user;
  final String nama;

  PmModel({required this.id_user, required this.nama});

  factory PmModel.fromJson(Map<String, dynamic> json) {
    return PmModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }
}

class DesainerModel {
  final String id_user;
  final String nama;

  DesainerModel({required this.id_user, required this.nama});

  factory DesainerModel.fromJson(Map<String, dynamic> json) {
    return DesainerModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }
}

class BackendModel {
  final String id_user;
  final String nama;

  BackendModel({required this.id_user, required this.nama});

  factory BackendModel.fromJson(Map<String, dynamic> json) {
    return BackendModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }
}

class FrontendModel {
  final String id_user;
  final String nama;

  FrontendModel({required this.id_user, required this.nama});

  factory FrontendModel.fromJson(Map<String, dynamic> json) {
    return FrontendModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }
}
