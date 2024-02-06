class PersonilModel {
  String? id_personil;
  String? id_user_pm;
  String? desainer1;
  String? desainer2;
  String? be_web1;
  String? be_web2;
  String? be_web3;
  String? be_mobile1;
  String? be_mobile2;
  String? be_mobile3;
  String? fe_web1;
  String? fe_mobile1;

  PersonilModel({
    this.id_personil,
    this.id_user_pm,
    this.desainer1,
    this.desainer2,
    this.be_web1,
    this.be_web2,
    this.be_web3,
    this.be_mobile1,
    this.be_mobile2,
    this.be_mobile3,
    this.fe_web1,
    this.fe_mobile1,
  });

  factory PersonilModel.fromJson(Map<String, dynamic> json) {
    return PersonilModel(
      id_personil: json['id_personil']?.toString(),
      id_user_pm: json['id_user_pm']?.toString(),
      desainer1: json['desainer1']?.toString(),
      desainer2: json['desainer2']?.toString(),
      be_web1: json['be_web1']?.toString(),
      be_web2: json['be_web2']?.toString(),
      be_web3: json['be_web3']?.toString(),
      be_mobile1: json['be_mobile1']?.toString(),
      be_mobile2: json['be_mobile2']?.toString(),
      be_mobile3: json['be_mobile3']?.toString(),
      fe_web1: json['fe_web1']?.toString(),
      fe_mobile1: json['fe_mobile1']?.toString(),
    );
  }
}
