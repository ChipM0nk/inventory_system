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
    this.dataRowHeight = 50,
    this.columnSpacing = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: PaginatedDataTable(
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
      ),
    );
  }
}
