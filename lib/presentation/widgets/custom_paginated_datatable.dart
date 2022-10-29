import 'package:flutter/material.dart';

@immutable
class CustomPaginatedDataTable extends StatelessWidget {
  final DataTableSource source;
  final List<DataColumn> dataColumns;
  final int? sortIndex;
  final bool sortAscending;
  final int rowsPerPage;
  final Text? header;
  final double dataRowHeight;
  final double columnSpacing;

  const CustomPaginatedDataTable({
    Key? key,
    required this.source,
    required this.dataColumns,
    this.sortIndex,
    required this.sortAscending,
    required this.rowsPerPage,
    this.header,
    this.dataRowHeight = 40,
    this.columnSpacing = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: header,
      showCheckboxColumn: false,
      dataRowHeight: dataRowHeight,
      columnSpacing: columnSpacing,
      horizontalMargin: 10,
      rowsPerPage: rowsPerPage,
      sortColumnIndex: sortIndex,
      sortAscending: sortAscending,
      showFirstLastButtons: true,
      columns: dataColumns,
      source: source,
    );
  }
}
