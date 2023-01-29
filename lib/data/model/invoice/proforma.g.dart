// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proforma.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proforma _$ProformaFromJson(Map<String, dynamic> json) => Proforma(
      proformaId: json['proformaId'] as int?,
      deliveryNo: json['deliveryNo'] as String?,
      dueDate: json['dueDate'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      contactPerson: json['contactPerson'] as String?,
      shippingMethod: json['shippingMethod'] as String,
      deliveredBy: json['deliveredBy'] as String?,
    );

Map<String, dynamic> _$ProformaToJson(Proforma instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('proformaId', instance.proformaId);
  writeNotNull('deliveryNo', instance.deliveryNo);
  writeNotNull('dueDate', instance.dueDate);
  writeNotNull('deliveryDate', instance.deliveryDate);
  writeNotNull('contactPerson', instance.contactPerson);
  val['shippingMethod'] = instance.shippingMethod;
  writeNotNull('deliveredBy', instance.deliveredBy);
  return val;
}
