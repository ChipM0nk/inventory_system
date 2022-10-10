// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['productId'] as int?,
      productCode: json['productCode'] as String,
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

  writeNotNull('productId', instance.productId);
  val['productCode'] = instance.productCode;
  val['productName'] = instance.productName;
  val['productDescription'] = instance.productDescription;
  val['productPrice'] = instance.productPrice;
  val['productQuantity'] = instance.productQuantity;
  val['productUnit'] = instance.productUnit;
  val['supplier'] = instance.supplier.toJson();
  val['category'] = instance.category.toJson();
  return val;
}
