import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PurchaseItemGridDataSource extends DataGridSource {
  List<DataGridRow> _purchaseItems = [];
  final bool editable;
  final Function(PurchaseItem)? deletePurchaseItem;
  PurchaseItemGridDataSource(
      {required List<PurchaseItem> purchaseItems,
      this.editable = false,
      this.deletePurchaseItem}) {
    _purchaseItems = purchaseItems
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              editable
                  ? DataGridCell<PurchaseItem>(
                      columnName: "purchaseitem", value: e)
                  : DataGridCell<String>(
                      columnName: "Product Code", value: e.product.productCode),
              DataGridCell<String>(
                  columnName: "Product Name", value: e.product.productName),
              DataGridCell<String>(
                  columnName: "Product Description",
                  value: e.product.productDescription),
              DataGridCell<String>(
                  columnName: "Price",
                  value: Util.convertToCurrency(e.itemAmount).toString()),
              DataGridCell<double>(columnName: "QTY", value: e.quantity),
              DataGridCell<String>(
                  columnName: "Total",
                  value:
                      'PHP ${Util.convertToCurrency(e.itemTotalAmount).toString()}'),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _purchaseItems;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'Price' ||
                dataGridCell.columnName == 'QTY' ||
                dataGridCell.columnName == 'Total')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(5.0),
        child: (dataGridCell.columnName == 'Product Description' ||
                dataGridCell.columnName == 'Product Name' ||
                dataGridCell.columnName == 'Product Code')
            ? Tooltip(
                message: dataGridCell.value.toString(),
                child: Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ))
            : (dataGridCell.columnName == 'purchaseitem')
                ? Row(
                    children: [
                      editable
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.delete,
                                size: 15,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  deletePurchaseItem!(dataGridCell.value))
                          : const SizedBox(width: 0),
                      Text(dataGridCell.value.product.productCode.toString()),
                    ],
                  )
                : Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
