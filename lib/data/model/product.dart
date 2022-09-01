// ignore: depend_on_referenced_packages

import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Product {
  @JsonKey(name: "id")
  @JsonKey(name: "productId")
  int? productId;
  final String productCode;
  final String productName;
  final String productDescription;
  final double productPrice;
  final double productQuantity;
  final String productUnit;
  final Supplier supplier;
  final Category category;

  Product(
      {this.productId,
      required this.productCode,
      required this.productName,
      required this.productDescription,
      required this.productPrice,
      required this.productQuantity,
      required this.productUnit,
      required this.supplier,
      required this.category});

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Connect the generated [_$ProductToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
