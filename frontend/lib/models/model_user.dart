// user.dart
class User {
  final String idUser;
  final String userName;
  final String userDisplayName;
  final int role;
  final String email;
  final String password;
  final DateTime? created;
  final String? createdBy;
  final DateTime? updated;
  final String? updatedBy;
  final User? createdByUser;
  final User? updatedByUser;

  User({
    required this.idUser,
    required this.userName,
    required this.userDisplayName,
    required this.role,
    required this.email,
    required this.password,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.createdByUser,
    this.updatedByUser,
  });

  // Factory constructor to create a User instance from JSON.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['idUser'],
      userName: json['userName'],
      userDisplayName: json['userDisplayName'],
      role: json['role'],
      email: json['email'],
      password: json['password'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      createdBy: json['createdBy'],
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
      updatedBy: json['updatedBy'],
      createdByUser: json['createdByUser'] != null
          ? User.fromJson(json['createdByUser'])
          : null,
      updatedByUser: json['updatedByUser'] != null
          ? User.fromJson(json['updatedByUser'])
          : null,
    );
  }

  // Method to convert a User instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'userName': userName,
      'userDisplayName': userDisplayName,
      'role': role,
      'email': email,
      'password': password,
      'created': created?.toIso8601String(),
      'createdBy': createdBy,
      'updated': updated?.toIso8601String(),
      'updatedBy': updatedBy,
      'createdByUser': createdByUser?.toJson(),
      'updatedByUser': updatedByUser?.toJson(),
    };
  }
}
