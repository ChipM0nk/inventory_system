// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      categoryId: json['id'] as int?,
      categoryCode: json['categoryCode'] as String,
      categoryName: json['categoryName'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.categoryId);
  val['categoryCode'] = instance.categoryCode;
  val['categoryName'] = instance.categoryName;
  return val;
}
