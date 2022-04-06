import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {
  final String username;
  final String id;
  final List<Object> linked_accounts;
  final String email;

  UserModel(
      {required this.username,
      required this.id,
      required this.email,
      required this.linked_accounts});
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
