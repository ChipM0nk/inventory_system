import 'package:edar_app/data/model/supplier.dart';
import 'package:flutter/material.dart';

typedef OnRowSelect = void Function(int index);
typedef OnDeleteClick = void Function(int index);
typedef OnItemClick = void Function(Supplier supplier);

class SupplierData extends DataTableSource {
  final List<Supplier> data;
  final OnDeleteClick onDeleteClick;
  final OnItemClick onItemClick;

  SupplierData(
      {required this.data,
      required this.onDeleteClick,
      required this.onItemClick});

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
          Text(dataItem.supplierName),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.supplierContactNumber),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.supplierEmailAdd),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          SizedBox(
              width: 300,
              child: Tooltip(
                message: dataItem.supplierAddress,
                child: Text(
                  dataItem.supplierAddress,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
            const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 92, 13, 6),
            ),
            onTap: () => onDeleteClick(dataItem.supplierId!)),
      ],
    );
  }
}
