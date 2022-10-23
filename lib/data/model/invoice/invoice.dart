// ignore: depend_on_referenced_packages
import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/data/model/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'invoice.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class Invoice {
  final int? invoiceId;
  final String invoiceNo;
  final String customerName;
  final String? customerAddress;
  final String? contactNo;
  final String? salesPerson;
  final String poNumber;
  final String purchaseDate;
  final String paymentType;
  final String paymentTerm;
  final String tinNumber;
  final String dueDate;
  final List<InvoiceItem> invoiceItems;
  final double totalAmount;

  const Invoice({
    this.invoiceId,
    required this.invoiceNo,
    required this.customerName,
    this.customerAddress,
    this.contactNo,
    this.salesPerson,
    required this.poNumber,
    required this.purchaseDate,
    required this.paymentType,
    required this.paymentTerm,
    required this.tinNumber,
    required this.dueDate,
    required this.invoiceItems,
    required this.totalAmount,
  });
  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  /// Connect the generated [_$InvoiceToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
