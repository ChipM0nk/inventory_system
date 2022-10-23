// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItem _$PurchaseItemFromJson(Map<String, dynamic> json) => PurchaseItem(
      purchaseItemId: json['purchaseItemId'] as int?,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      itemAmount: (json['itemAmount'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      itemTotalAmount: (json['itemTotalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$PurchaseItemToJson(PurchaseItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('purchaseItemId', instance.purchaseItemId);
  val['product'] = instance.product.toJson();
  val['itemAmount'] = instance.itemAmount;
  val['quantity'] = instance.quantity;
  val['itemTotalAmount'] = instance.itemTotalAmount;
  return val;
}
