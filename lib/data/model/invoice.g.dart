// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      invoiceId: json['id'] as int?,
      invoiceNumber: json['invoiceNumber'] as String,
      customerName: json['customerName'] as String,
      customerAddress: json['customerAddress'] as String?,
      contactNo: json['contactNo'] as String?,
      salesPerson: User.fromJson(json['salesPerson'] as Map<String, dynamic>),
      poNumber: json['poNumber'] as String,
      purchaseDate: json['purchaseDate'] as String,
      paymentTerm: json['paymentTerm'] as String,
      tinNumber: json['tinNumber'] as String,
      dueDate: json['dueDate'] as String,
      invoiceItems: (json['invoiceItems'] as List<dynamic>)
          .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.invoiceId);
  val['invoiceNumber'] = instance.invoiceNumber;
  val['customerName'] = instance.customerName;
  writeNotNull('customerAddress', instance.customerAddress);
  writeNotNull('contactNo', instance.contactNo);
  val['salesPerson'] = instance.salesPerson.toJson();
  val['poNumber'] = instance.poNumber;
  val['purchaseDate'] = instance.purchaseDate;
  val['paymentTerm'] = instance.paymentTerm;
  val['tinNumber'] = instance.tinNumber;
  val['dueDate'] = instance.dueDate;
  val['invoiceItems'] = instance.invoiceItems.map((e) => e.toJson()).toList();
  return val;
}
