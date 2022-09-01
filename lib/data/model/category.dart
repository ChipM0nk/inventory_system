// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Category {
  @JsonKey(name: "id")
  @JsonKey(name: "categoryId")
  int? categoryId;
  final String categoryCode;
  final String categoryName;

  Category({
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
