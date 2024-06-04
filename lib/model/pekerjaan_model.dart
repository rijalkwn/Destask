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
  DateTime created_at;
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
    required this.created_at,
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
        created_at: DateTime.parse(json['created_at']),
        data_tambahan: DataTambahan.fromJson(json['data_tambahan']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pekerjaan': id_pekerjaan,
      'id_status_pekerjaan': id_status_pekerjaan,
      'id_kategori_pekerjaan': id_kategori_pekerjaan,
      'nama_pekerjaan': nama_pekerjaan,
      'pelanggan': pelanggan,
      'jenis_pelanggan': jenis_pelanggan,
      'nama_pic': nama_pic,
      'email_pic': email_pic,
      'nowa_pic': nowa_pic,
      'jenis_layanan': jenis_layanan,
      'nominal_harga': nominal_harga,
      'deskripsi_pekerjaan': deskripsi_pekerjaan,
      'target_waktu_selesai': target_waktu_selesai,
      'persentase_selesai': persentase_selesai,
      'waktu_selesai': waktu_selesai,
      'created_at': created_at,
      'data_tambahan': data_tambahan.toJson(),
    };
  }
}

class DataTambahan {
  final String nama_status_pekerjaan;
  final String nama_kategori_pekerjaan;
  final List<PmModel> pm;
  final List<DesainerModel> desainer;
  final List<BackendWebModel> backend_web;
  final List<BackendMobileModel> backend_mobile;
  final List<FrontendWebModel> frontend_web;
  final List<FrontendMobileModel> frontend_mobile;
  final List<TesterModel> tester;
  final List<AdminModel> admin;
  final List<HelpdeskModel> helpdesk;
  final String persentase_task_selesai;

  DataTambahan({
    required this.nama_status_pekerjaan,
    required this.nama_kategori_pekerjaan,
    required this.pm,
    required this.desainer,
    required this.backend_web,
    required this.backend_mobile,
    required this.frontend_web,
    required this.frontend_mobile,
    required this.tester,
    required this.admin,
    required this.helpdesk,
    required this.persentase_task_selesai,
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

    List<BackendWebModel> backendWebList = [];
    if (json['backend_web'] != null) {
      json['backend_web'].forEach((backendWeb) {
        backendWebList.add(BackendWebModel.fromJson(backendWeb));
      });
    }

    List<BackendMobileModel> backendMobileList = [];
    if (json['backend_mobile'] != null) {
      json['backend_mobile'].forEach((backendMobile) {
        backendMobileList.add(BackendMobileModel.fromJson(backendMobile));
      });
    }

    List<FrontendWebModel> frontendWebList = [];
    if (json['frontend_web'] != null) {
      json['frontend_web'].forEach((frontendWeb) {
        frontendWebList.add(FrontendWebModel.fromJson(frontendWeb));
      });
    }

    List<FrontendMobileModel> frontendMobileList = [];
    if (json['frontend_mobile'] != null) {
      json['frontend_mobile'].forEach((frontendMobile) {
        frontendMobileList.add(FrontendMobileModel.fromJson(frontendMobile));
      });
    }

    //tester
    List<TesterModel> testerList = [];
    if (json['tester'] != null) {
      json['tester'].forEach((tester) {
        testerList.add(TesterModel.fromJson(tester));
      });
    }

    //admin
    List<AdminModel> adminList = [];
    if (json['admin'] != null) {
      json['admin'].forEach((admin) {
        adminList.add(AdminModel.fromJson(admin));
      });
    }

    //helpdesk
    List<HelpdeskModel> helpdeskList = [];
    if (json['helpdesk'] != null) {
      json['helpdesk'].forEach((helpdesk) {
        helpdeskList.add(HelpdeskModel.fromJson(helpdesk));
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
        tester: testerList,
        admin: adminList,
        helpdesk: helpdeskList,
        persentase_task_selesai:
            json['persentase_task_selesai']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_status_pekerjaan': nama_status_pekerjaan,
      'nama_kategori_pekerjaan': nama_kategori_pekerjaan,
      'pm': pm,
      'desainer': desainer,
      'backend_web': backend_web,
      'backend_mobile': backend_mobile,
      'frontend_web': frontend_web,
      'frontend_mobile': frontend_mobile,
      'tester': tester,
      'admin': admin,
      'helpdesk': helpdesk,
      'persentase_task_selesai': persentase_task_selesai,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
  }
}

class BackendWebModel {
  final String id_user;
  final String nama;

  BackendWebModel({required this.id_user, required this.nama});

  factory BackendWebModel.fromJson(Map<String, dynamic> json) {
    return BackendWebModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
  }
}

class BackendMobileModel {
  final String id_user;
  final String nama;

  BackendMobileModel({required this.id_user, required this.nama});

  factory BackendMobileModel.fromJson(Map<String, dynamic> json) {
    return BackendMobileModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
  }
}

class FrontendWebModel {
  final String id_user;
  final String nama;

  FrontendWebModel({required this.id_user, required this.nama});

  factory FrontendWebModel.fromJson(Map<String, dynamic> json) {
    return FrontendWebModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
  }
}

class FrontendMobileModel {
  final String id_user;
  final String nama;

  FrontendMobileModel({required this.id_user, required this.nama});

  factory FrontendMobileModel.fromJson(Map<String, dynamic> json) {
    return FrontendMobileModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
  }
}

//tester
class TesterModel {
  final String id_user;
  final String nama;

  TesterModel({required this.id_user, required this.nama});

  factory TesterModel.fromJson(Map<String, dynamic> json) {
    return TesterModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
  }
}

//admin
class AdminModel {
  final String id_user;
  final String nama;

  AdminModel({required this.id_user, required this.nama});

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
  }
}

//helpdesk
class HelpdeskModel {
  final String id_user;
  final String nama;

  HelpdeskModel({required this.id_user, required this.nama});

  factory HelpdeskModel.fromJson(Map<String, dynamic> json) {
    return HelpdeskModel(
      id_user: json['id_user'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'nama': nama,
    };
  }
}
