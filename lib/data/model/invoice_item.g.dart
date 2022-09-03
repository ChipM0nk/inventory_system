// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => InvoiceItem(
      invoiceitemId: json['id'] as int?,
      sn: json['sn'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceItemToJson(InvoiceItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.invoiceitemId);
  val['sn'] = instance.sn;
  val['product'] = instance.product.toJson();
  val['quantity'] = instance.quantity;
  val['price'] = instance.price;
  val['amount'] = instance.amount;
  return val;
}
