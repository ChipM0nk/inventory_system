// ignore: depend_on_referenced_packages
import 'package:edar_app/data/model/product.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'invoice_item.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class InvoiceItem {
  final int? invoiceitemId;
  final int sn;
  final Product product;
  final double quantity;
  final double price;
  final double totalAmount;

  const InvoiceItem({
    this.invoiceitemId,
    required this.sn,
    required this.product,
    required this.quantity,
    required this.price,
    required this.totalAmount,
  });

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);

  /// Connect the generated [_$InvoiceItemToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$InvoiceItemToJson(this);
}
