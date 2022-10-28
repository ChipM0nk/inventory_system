// ignore: depend_on_referenced_packages
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'purchase.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class Purchase {
  final int? purchaseId;
  final String purchaseNo;
  final String purchaseDate;
  final String batchCode;
  final Supplier supplier;
  final String? remarks;
  final List<PurchaseItem> purchaseItems;
  final String? staff;
  final double totalAmount;

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  ///
  ///
  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  const Purchase({
    this.purchaseId,
    required this.purchaseNo,
    required this.purchaseDate,
    required this.batchCode,
    required this.supplier,
    this.remarks,
    required this.purchaseItems,
    this.staff,
    required this.totalAmount,
  });

  /// Connect the generated [_$PurchaseToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);

  @override
  bool operator ==(Object other) {
    return other is Purchase && other.purchaseId == purchaseId;
  }

  @override
  int get hashCode => purchaseId.hashCode;

  @override
  String toString() => '{ id: $purchaseId }';
}
