// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
      supplierId: json['supplierId'] as int?,
      supplierName: json['supplierName'] as String,
      supplierAddress: json['supplierAddress'] as String,
      supplierEmailAdd: json['supplierEmailAdd'] as String,
      supplierContactNumber: json['supplierContactNumber'] as String,
    );

Map<String, dynamic> _$SupplierToJson(Supplier instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('supplierId', instance.supplierId);
  val['supplierName'] = instance.supplierName;
  val['supplierAddress'] = instance.supplierAddress;
  val['supplierEmailAdd'] = instance.supplierEmailAdd;
  val['supplierContactNumber'] = instance.supplierContactNumber;
  return val;
}
