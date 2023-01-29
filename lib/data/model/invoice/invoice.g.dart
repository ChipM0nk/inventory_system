// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      invoiceId: json['invoiceId'] as int?,
      invoiceNo: json['invoiceNo'] as String?,
      customerName: json['customerName'] as String,
      customerAddress: json['customerAddress'] as String?,
      contactNo: json['contactNo'] as String?,
      staff: json['staff'] as String?,
      poNumber: json['poNumber'] as String?,
      purchaseDate: json['purchaseDate'] as String,
      paymentType: json['paymentType'] as String,
      paymentTerm: json['paymentTerm'] as String,
      tinNumber: json['tinNumber'] as String,
      proforma: json['proforma'] == null
          ? null
          : Proforma.fromJson(json['proforma'] as Map<String, dynamic>),
      remarks: json['remarks'] as String?,
      invoiceItems: (json['invoiceItems'] as List<dynamic>)
          .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      downPayment: (json['downPayment'] as num?)?.toDouble(),
      trxnStatus: json['trxnStatus'] as String?,
      invoiceType: json['invoiceType'] as String?,
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('invoiceId', instance.invoiceId);
  writeNotNull('invoiceNo', instance.invoiceNo);
  val['customerName'] = instance.customerName;
  writeNotNull('customerAddress', instance.customerAddress);
  writeNotNull('contactNo', instance.contactNo);
  writeNotNull('staff', instance.staff);
  writeNotNull('poNumber', instance.poNumber);
  val['purchaseDate'] = instance.purchaseDate;
  val['paymentType'] = instance.paymentType;
  val['paymentTerm'] = instance.paymentTerm;
  val['tinNumber'] = instance.tinNumber;
  writeNotNull('proforma', instance.proforma?.toJson());
  writeNotNull('remarks', instance.remarks);
  val['invoiceItems'] = instance.invoiceItems.map((e) => e.toJson()).toList();
  val['totalAmount'] = instance.totalAmount;
  writeNotNull('downPayment', instance.downPayment);
  writeNotNull('trxnStatus', instance.trxnStatus);
  writeNotNull('invoiceType', instance.invoiceType);
  return val;
}
