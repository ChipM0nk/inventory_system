// ignore: depend_on_referenced_packages

import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class Product {
  final int? productId;
  final String productCode;
  final String productName;
  final String productDescription;
  final double productPrice;
  final double currentStock;
  final String unit;
  final Supplier supplier;
  final Category category;

  const Product({
    this.productId,
    required this.productCode,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.currentStock,
    required this.unit,
    required this.supplier,
    required this.category,
  });

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Connect the generated [_$ProductToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  bool operator ==(Object other) {
    return other is Product && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;

  @override
  String toString() => '{ id: $productId }';
}
