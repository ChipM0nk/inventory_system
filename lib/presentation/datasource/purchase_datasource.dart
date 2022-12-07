import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:flutter/material.dart';

typedef OnRowSelect = void Function(int index);
typedef OnDeleteClick = void Function(int index);
typedef OnItemClick = void Function(Purchase purchase);

class PurchaseData extends DataTableSource {
  final List<Purchase> data;
  final OnItemClick onItemClick;

  PurchaseData({required this.data, required this.onItemClick});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    final dataItem = data[index];

    return DataRow.byIndex(
      index: index,
      selected: false,
      cells: <DataCell>[
        DataCell(
          Text(dataItem.supplierInvoiceNo),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.batchCode!),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.supplier.supplierName),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.purchaseDate),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(Util.convertToCurrency(dataItem.totalAmount)),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.staff ?? ""),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.trxnStatus ?? ""),
          onTap: () => onItemClick(dataItem),
        ),
      ],
    );
  }
}
