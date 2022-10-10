// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      purchaseId: json['purchaseId'] as int?,
      purchaseNo: json['purchaseNo'] as String,
      purchaseDate: json['purchaseDate'] as String,
      batchCode: json['batchCode'] as String,
      supplier: Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      purchaseItems: (json['purchaseItems'] as List<dynamic>)
          .map((e) => PurchaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$PurchaseToJson(Purchase instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('purchaseId', instance.purchaseId);
  val['purchaseNo'] = instance.purchaseNo;
  val['purchaseDate'] = instance.purchaseDate;
  val['batchCode'] = instance.batchCode;
  val['supplier'] = instance.supplier.toJson();
  val['purchaseItems'] = instance.purchaseItems.map((e) => e.toJson()).toList();
  val['totalAmount'] = instance.totalAmount;
  return val;
}
