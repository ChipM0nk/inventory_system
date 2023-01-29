import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'proforma.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class Proforma {
  final int? proformaId;
  final String? deliveryNo;
  final String? dueDate;
  final String? deliveryDate;
  final String? contactPerson;
  final String shippingMethod;
  final String? deliveredBy;

  const Proforma({
    this.proformaId,
    this.deliveryNo,
    this.dueDate,
    this.deliveryDate,
    this.contactPerson,
    required this.shippingMethod,
    this.deliveredBy,
  });

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Proforma.fromJson(Map<String, dynamic> json) =>
      _$ProformaFromJson(json);

  /// Connect the generated [_$ProformaToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProformaToJson(this);
}
