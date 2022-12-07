// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      deliveryNo: json['deliveryNo'] as String?,
      dueDate: json['dueDate'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      contactPerson: json['contactPerson'] as String?,
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('deliveryNo', instance.deliveryNo);
  writeNotNull('dueDate', instance.dueDate);
  writeNotNull('deliveryDate', instance.deliveryDate);
  writeNotNull('contactPerson', instance.contactPerson);
  return val;
}
