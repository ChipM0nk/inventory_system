import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:flutter/material.dart';

typedef OnRowSelect = void Function(int index);
typedef OnDeleteClick = void Function(int index);
typedef OnItemClick = void Function(Invoice invoice);

class InvoiceData extends DataTableSource {
  final List<Invoice> data;
  final OnItemClick onItemClick;

  InvoiceData({
    required this.data,
    required this.onItemClick,
  });

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
          Text(dataItem.invoiceNo!),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.customerName),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.contactNo.toString()),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.purchaseDate),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.totalAmount.toString()),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.staff ?? dataItem.staff!),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.trxnStatus ?? dataItem.trxnStatus!),
          onTap: () => onItemClick(dataItem),
        ),
      ],
    );
  }
}
