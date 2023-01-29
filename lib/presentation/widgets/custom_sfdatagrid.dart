import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CustomSfDataGrid extends StatelessWidget {
  final DataGridSource source;
  final List<GridColumn> columns;
  final Container? footer;
  final List<StackedHeaderRow> stackedHeaderRows;
  final double stackedHeaderRowHeight;
  final double rowHeight;
  final GlobalKey<SfDataGridState> sfKey;
  const CustomSfDataGrid(
      {super.key,
      required this.sfKey,
      required this.source,
      required this.columns,
      this.footer,
      this.stackedHeaderRowHeight = 220,
      this.rowHeight = 30,
      required this.stackedHeaderRows});

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(headerColor: Colors.green.shade200),
      child: SfDataGrid(
          key: sfKey,
          footerFrozenRowsCount: 1,
          onQueryRowHeight: (details) {
            // Set the row height as 70.0 to the column header row.
            return details.rowIndex == 0 && stackedHeaderRows.isNotEmpty
                ? stackedHeaderRowHeight
                : rowHeight;
          },
          stackedHeaderRows: stackedHeaderRows,
          footer: footer,
          footerHeight: rowHeight,
          rowHeight: rowHeight,
          headerRowHeight: rowHeight,
          allowEditing: false,
          highlightRowOnHover: false,
          source: source,
          columns: columns),
    );
  }
}
