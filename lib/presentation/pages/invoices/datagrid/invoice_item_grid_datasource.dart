import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InvoiceItemGriDataSource extends DataGridSource {
  InvoiceItemGriDataSource({required List<InvoiceItem> invoiceItems}) {
    _invoiceItems = invoiceItems
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                  columnName: "prodname", value: e.product.productName),
              DataGridCell<String>(
                  columnName: "proddesc", value: e.product.productDescription),
              DataGridCell<double>(columnName: "price", value: e.price),
              DataGridCell<double>(columnName: "qty", value: e.quantity),
              DataGridCell<double>(columnName: "total", value: e.totalAmount),
            ],
          ),
        )
        .toList();
  }
  List<DataGridRow> _invoiceItems = [];

  @override
  List<DataGridRow> get rows => _invoiceItems;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'price' ||
                dataGridCell.columnName == 'qty' ||
                dataGridCell.columnName == 'total')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(5.0),
        child: (dataGridCell.columnName == 'prodname' ||
                dataGridCell.columnName == 'proddesc')
            ? Tooltip(
                message: dataGridCell.value.toString(),
                child: Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ))
            : Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
