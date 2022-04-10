import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {
  final String username;
  final String? id;
  final List<Object>? linked_accounts;
  final String email;
  final String? password;
  final File? image;

  void set linked_accounts(List<Object>? linked_accounts) {
    this.linked_accounts = linked_accounts;
  }

  UserModel(
      {required this.username,
      this.id,
      required this.email,
      this.password,
      this.image,
      this.linked_accounts});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class AuthModel {
  final String accessToken;
  final String refreshtoken;
  AuthModel({required this.refreshtoken, required this.accessToken});
  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}
