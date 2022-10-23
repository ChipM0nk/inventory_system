// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as int?,
      username: json['username'] as String,
      password: json['password'] as String?,
      confirmPassword: json['confirmPassword'] as String?,
      token: json['token'] as String?,
      menuList: (json['menuList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userId', instance.userId);
  val['username'] = instance.username;
  writeNotNull('password', instance.password);
  writeNotNull('confirmPassword', instance.confirmPassword);
  writeNotNull('token', instance.token);
  writeNotNull('menuList', instance.menuList);
  return val;
}
