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
      image_path: json['image_path'] as String?,
      linked_accounts: (json['linked_accounts'] as List<dynamic>?)
          ?.map((e) => e as Object)
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'username': instance.username,
      'id': instance.id,
      'linked_accounts': instance.linked_accounts,
      'email': instance.email,
      'password': instance.password,
      'image_path': instance.image_path,
    };

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      refreshtoken: json['refreshtoken'] as String,
      accessToken: json['accessToken'] as String,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshtoken': instance.refreshtoken,
    };
