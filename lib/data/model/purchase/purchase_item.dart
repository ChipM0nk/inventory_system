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
  final double purchaseAmount;
  final double batchQuantity;
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
    required this.purchaseAmount,
    required this.batchQuantity,
    required this.itemTotalAmount,
  });

  /// Connect the generated [_$PurchaseToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);

  @override
  bool operator ==(Object other) {
    return other is PurchaseItem && other.purchaseItemId == purchaseItemId;
  }

  @override
  int get hashCode => purchaseItemId.hashCode;

  @override
  String toString() => '{ id: $purchaseItemId }';
}
