class UserModel {
  String id_user;
  String id_usergroup;
  String username;
  String email;
  String password;
  String user_level;
  String nama;
  String foto_profil;

  UserModel({
    required this.id_user,
    required this.id_usergroup,
    required this.username,
    required this.email,
    required this.password,
    required this.user_level,
    required this.nama,
    required this.foto_profil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id_user: json['id_user'],
      id_usergroup: json['id_usergroup'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      user_level: json['user_level'],
      nama: json['nama'],
      foto_profil: json['foto_profil'],
    );
  }
}
