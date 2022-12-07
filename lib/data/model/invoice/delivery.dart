import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'delivery.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
@immutable
class Delivery {
  final String? deliveryNo;
  final String? dueDate;
  final String? deliveryDate;
  final String? contactPerson;

  const Delivery(
      {this.deliveryNo, this.dueDate, this.deliveryDate, this.contactPerson});

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  /// Connect the generated [_$DeliveryToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}
