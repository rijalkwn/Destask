class UserModel {
  final String? id_user;
  final String? id_usergroup;
  final String? username;
  final String? email;
  final String? password;
  final String? user_role;
  final String? user_level;
  final String? nama;
  final String? status_keaktifan;
  final String? foto_profil;

  UserModel({
    this.id_user,
    this.id_usergroup,
    this.username,
    this.email,
    this.password,
    this.user_role,
    this.user_level,
    this.nama,
    this.status_keaktifan,
    this.foto_profil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id_user: json['id_user'],
      id_usergroup: json['id_usergroup'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      user_role: json['user_role'],
      user_level: json['user_level'],
      nama: json['nama'],
      status_keaktifan: json['status_keaktifan'],
      foto_profil: json['foto_profil'],
    );
  }
}
