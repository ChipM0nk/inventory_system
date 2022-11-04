import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InvoiceItemGridDataSource extends DataGridSource {
  List<DataGridRow> _invoiceItems = [];
  final bool editable;
  final Function(InvoiceItem)? deleteInvoiceItem;
  InvoiceItemGridDataSource(
      {required List<InvoiceItem> invoiceItems,
      this.editable = false,
      this.deleteInvoiceItem}) {
    _invoiceItems = invoiceItems
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<InvoiceItem>(columnName: "prodcode", value: e),
              DataGridCell<String>(
                  columnName: "prodname", value: e.product.productName),
              DataGridCell<String>(
                  columnName: "proddesc", value: e.product.productDescription),
              DataGridCell<String>(
                  columnName: "price",
                  value: Util.convertToCurrency(e.price).toString()),
              DataGridCell<double>(columnName: "qty", value: e.quantity),
              DataGridCell<String>(
                  columnName: "total",
                  value:
                      'PHP ${Util.convertToCurrency(e.totalAmount).toString()}'),
            ],
          ),
        )
        .toList();
  }

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
        child: (dataGridCell.columnName == 'proddesc' ||
                dataGridCell.columnName == 'prodname')
            ? Tooltip(
                message: dataGridCell.value.toString(),
                child: Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ))
            : (dataGridCell.columnName == 'prodcode')
                ? Row(
                    children: [
                      editable
                          ? IconButton(
                              padding: const EdgeInsets.only(right: 15),
                              constraints: const BoxConstraints(
                                  maxHeight: 20, maxWidth: 20),
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  deleteInvoiceItem!(dataGridCell.value))
                          : const SizedBox(width: 0),
                      Text(dataGridCell.value.product.productCode.toString()),
                    ],
                  )
                : Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
