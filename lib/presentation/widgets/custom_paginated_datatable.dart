import 'package:flutter/material.dart';

class CustomPaginatedDataTable extends StatelessWidget {
  final DataTableSource source;
  final List<DataColumn> dataColumns;
  int? sortIndex;
  final bool sortAscending;
  final int rowsPerPage;
  Text? header;

  CustomPaginatedDataTable({
    Key? key,
    required this.source,
    required this.dataColumns,
    this.sortIndex,
    required this.sortAscending,
    required this.rowsPerPage,
    this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: PaginatedDataTable(
        header: header,
        showCheckboxColumn: false,
        columnSpacing: 50,
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
