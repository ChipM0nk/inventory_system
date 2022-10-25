import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CustomSfDataGrid extends StatelessWidget {
  final DataGridSource source;
  final List<GridColumn> columns;
  final Container? footer;
  final List<StackedHeaderRow> stackedHeaderRows;
  const CustomSfDataGrid(
      {super.key,
      required this.source,
      required this.columns,
      this.footer,
      required this.stackedHeaderRows});

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(headerColor: Colors.green.shade200),
      child: SfDataGrid(
          onQueryRowHeight: (details) {
            // Set the row height as 70.0 to the column header row.
            return details.rowIndex == 0 && stackedHeaderRows.isNotEmpty
                ? 70.0
                : 30.0;
          },
          stackedHeaderRows: stackedHeaderRows,
          footer: footer,
          footerHeight: 30,
          rowHeight: 30,
          headerRowHeight: 30,
          allowEditing: false,
          highlightRowOnHover: false,
          source: source,
          columns: columns),
    );
  }
}
