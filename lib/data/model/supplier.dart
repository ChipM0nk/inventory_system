import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'supplier.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class Supplier {
  @JsonKey(name: "id")
  @JsonKey(name: "supplierId")
  final int? supplierId;
  final String supplierName;
  final String supplierAddress;
  final String supplierContactNumber;

  const Supplier(
      {this.supplierId,
      required this.supplierName,
      required this.supplierAddress,
      required this.supplierContactNumber});

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);

  /// Connect the generated [_$SupplierModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}
