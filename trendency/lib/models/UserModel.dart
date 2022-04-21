import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {
  final String username;
  final String? id;
  final List<LinkedAccountsModel> linked_accounts;
  final String email;
  final String? password;
  @JsonKey(name: "profile_image")
  final String? image_path;
  String? accessToken;
  String? refreshToken;

  void set linked_accounts(List<LinkedAccountsModel> linked_accounts) {
    this.linked_accounts = linked_accounts;
  }

  UserModel(
      {required this.username,
      this.id,
      required this.email,
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
  final String platform;
  final String id;
  LinkedAccountsModel({required this.id, required this.platform});

  factory LinkedAccountsModel.fromJson(Map<String, dynamic> json) =>
      _$LinkedAccountsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LinkedAccountsModelToJson(this);
}
