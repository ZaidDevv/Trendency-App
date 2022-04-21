// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      username: json['username'] as String,
      id: json['id'] as String?,
      email: json['email'] as String,
      password: json['password'] as String?,
      image_path: json['profile_image'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      linked_accounts: (json['linked_accounts'] as List<dynamic>)
          .map((e) => LinkedAccountsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'username': instance.username,
      'id': instance.id,
      'linked_accounts': instance.linked_accounts,
      'email': instance.email,
      'password': instance.password,
      'profile_image': instance.image_path,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

LinkedAccountsModel _$LinkedAccountsModelFromJson(Map<String, dynamic> json) =>
    LinkedAccountsModel(
      id: json['id'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$LinkedAccountsModelToJson(
        LinkedAccountsModel instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'id': instance.id,
    };
