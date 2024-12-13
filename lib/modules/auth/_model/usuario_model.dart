class UserModel {
  final String uid;
  final String login;
  final String? nome;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.login,
    this.nome,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      login: json['login'],
      nome: json['nome'],
      isAdmin: json['isAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'login': login,
      'nome': nome,
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? uid,
    String? login,
    String? nome,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      login: login ?? this.login,
      nome: nome ?? this.nome,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
