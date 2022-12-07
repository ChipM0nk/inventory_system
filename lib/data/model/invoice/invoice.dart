// ignore: depend_on_referenced_packages
import 'package:edar_app/data/model/invoice/delivery.dart';
import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'invoice.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class Invoice {
  final int? invoiceId;
  final String? invoiceNo;
  final String customerName;
  final String? customerAddress;
  final String? contactNo;
  final String? staff;
  final String? poNumber;
  final String purchaseDate;
  final String paymentType;
  final String paymentTerm;
  final String tinNumber;
  final Delivery? delivery;
  final String? remarks;
  final List<InvoiceItem> invoiceItems;
  final double totalAmount;
  final String? trxnStatus;

  const Invoice(
      {this.invoiceId,
      this.invoiceNo,
      required this.customerName,
      this.customerAddress,
      this.contactNo,
      this.staff,
      this.poNumber,
      required this.purchaseDate,
      required this.paymentType,
      required this.paymentTerm,
      required this.tinNumber,
      this.delivery,
      this.remarks,
      required this.invoiceItems,
      required this.totalAmount,
      this.trxnStatus});
  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  /// Connect the generated [_$InvoiceToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
