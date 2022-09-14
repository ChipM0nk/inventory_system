// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItem _$PurchaseItemFromJson(Map<String, dynamic> json) => PurchaseItem(
      purchaseItemId: json['id'] as int?,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      purchaseAmount: (json['purchaseAmount'] as num).toDouble(),
      batchQuantity: (json['batchQuantity'] as num).toDouble(),
      itemTotalAmount: (json['itemTotalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$PurchaseItemToJson(PurchaseItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.purchaseItemId);
  val['product'] = instance.product.toJson();
  val['purchaseAmount'] = instance.purchaseAmount;
  val['batchQuantity'] = instance.batchQuantity;
  val['itemTotalAmount'] = instance.itemTotalAmount;
  return val;
}
