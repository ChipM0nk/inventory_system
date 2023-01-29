// ignore: depend_on_referenced_packages
import 'package:edar_app/data/model/product.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'purchase_item.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class PurchaseItem {
  final int? purchaseItemId;
  final Product product;
  final double itemAmount;
  final double quantity;
  final double itemTotalAmount;

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  ///
  ///
  ///
  ///
  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);
  const PurchaseItem({
    this.purchaseItemId,
    required this.product,
    required this.itemAmount,
    required this.quantity,
    required this.itemTotalAmount,
  });

  /// Connect the generated [_$PurchaseToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);
}
