// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['id'] as int?,
      productName: json['productName'] as String,
      productDescription: json['productDescription'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productQuantity: (json['productQuantity'] as num).toDouble(),
      productUnit: json['productUnit'] as String,
      supplier: Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductToJson(Product instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.productId);
  val['productName'] = instance.productName;
  val['productDescription'] = instance.productDescription;
  val['productPrice'] = instance.productPrice;
  val['productQuantity'] = instance.productQuantity;
  val['productUnit'] = instance.productUnit;
  val['supplier'] = instance.supplier.toJson();
  val['category'] = instance.category.toJson();
  return val;
}
