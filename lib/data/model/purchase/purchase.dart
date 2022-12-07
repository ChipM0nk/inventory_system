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
  final String supplierInvoiceNo;
  final String purchaseDate;
  final String? batchCode;
  final Supplier supplier;
  final String? remarks;
  final List<PurchaseItem> purchaseItems;
  final String? staff;
  final double totalAmount;
  final String? trxnStatus;

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  ///
  ///
  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  const Purchase(
      {this.purchaseId,
      required this.supplierInvoiceNo,
      required this.purchaseDate,
      this.batchCode,
      required this.supplier,
      this.remarks,
      required this.purchaseItems,
      this.staff,
      required this.totalAmount,
      this.trxnStatus});

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
