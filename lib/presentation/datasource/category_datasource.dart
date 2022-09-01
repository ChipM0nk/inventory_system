import 'package:edar_app/data/model/category.dart';
import 'package:flutter/material.dart';

typedef OnRowSelect = void Function(int index);
typedef OnDeleteClick = void Function(int index);
typedef OnItemClick = void Function(Category category);

class CategoryData extends DataTableSource {
  final List<Category> data;
  final OnDeleteClick onDeleteClick;
  final OnItemClick onItemClick;

  CategoryData(
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
          Text(dataItem.categoryCode),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.categoryName),
          onTap: () => onItemClick(dataItem),
        ),
        // DataCell(Text('${dataItem.categoryId}')),
        DataCell(
            const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 92, 13, 6),
            ),
            onTap: () => onDeleteClick(dataItem.categoryId!)),
      ],
    );
  }
}
