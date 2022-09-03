// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class Category {
  @JsonKey(name: "id")
  @JsonKey(name: "categoryId")
  final int? categoryId;
  final String categoryCode;
  final String categoryName;

  const Category({
    this.categoryId,
    required this.categoryCode,
    required this.categoryName,
  });

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  /// Connect the generated [_$CategoryToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
