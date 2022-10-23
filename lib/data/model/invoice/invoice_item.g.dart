// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => InvoiceItem(
      invoiceitemId: json['invoiceitemId'] as int?,
      sn: json['sn'] as int,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceItemToJson(InvoiceItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('invoiceitemId', instance.invoiceitemId);
  val['sn'] = instance.sn;
  val['product'] = instance.product.toJson();
  val['quantity'] = instance.quantity;
  val['price'] = instance.price;
  val['totalAmount'] = instance.totalAmount;
  return val;
}
