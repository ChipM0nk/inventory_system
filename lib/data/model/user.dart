import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class User {
  final int? userId;
  final String username;
  final String? password;
  final String? confirmPassword;
  final String? token;
  final List<String>? menuList;

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  const User({
    this.userId,
    required this.username,
    this.password,
    this.confirmPassword,
    this.token,
    this.menuList,
  });

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
