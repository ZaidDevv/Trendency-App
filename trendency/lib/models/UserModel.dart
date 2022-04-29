import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {
  final String username;
  final String? id;
  List<LinkedAccountsModel> linked_accounts = [];
  final String email;
  final String? password;
  @JsonKey(name: "profile_image")
  final String? image_path;
  String? accessToken;
  String? refreshToken;
  bool? is_verified;

  UserModel(
      {required this.username,
      this.id,
      required this.email,
      this.is_verified,
      this.password,
      this.image_path,
      this.accessToken,
      this.refreshToken,
      required this.linked_accounts});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class LinkedAccountsModel {
  String? platform;
  String? id;
  LinkedAccountsModel({this.id, this.platform});

  factory LinkedAccountsModel.fromJson(Map<String, dynamic> json) =>
      _$LinkedAccountsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LinkedAccountsModelToJson(this);
}
