import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class SfDataGridToPdfConverterExt extends DataGridToPdfConverter {
  ByteData imageData = ByteData(0);
  SfDataGridToPdfConverterExt(this.imageData);
  @override
  void exportColumnHeader(SfDataGrid dataGrid, GridColumn column,
      String columnName, PdfGrid pdfGrid) {
    // TODO: Add your requirements column header

    pdfGrid.columns[0].width = 75;
    pdfGrid.columns[1].width = 225;
    pdfGrid.columns[3].width = 30;

    pdfGrid.headers[0].cells[0].stringFormat.alignment =
        PdfTextAlignment.center;
    pdfGrid.headers[0].cells[1].stringFormat.alignment =
        PdfTextAlignment.center;
    pdfGrid.headers[0].height = 20;
    pdfGrid.headers[0].style = PdfGridCellStyle(
        backgroundBrush: PdfSolidBrush(PdfColor(
          165,
          214,
          167,
        )),
        font: PdfStandardFont(PdfFontFamily.helvetica, 10,
            style: PdfFontStyle.bold));

    super.exportColumnHeader(dataGrid, column, columnName, pdfGrid);
  }

  @override
  // TODO: implement excludeColumns
  List<String> get excludeColumns => ["Product Name"];
  @override
  // TODO: implement autoColumnWidth
  bool get autoColumnWidth => true;

  @override
  // TODO: implement fitAllColumnsInOnePage
  bool get fitAllColumnsInOnePage => true;

  @override
  DataGridPdfHeaderFooterExportCallback? get headerFooterExport =>
      (DataGridPdfHeaderFooterExportDetails details) {
        final double width = details.pdfPage.getClientSize().width;
        final PdfPageTemplateElement header =
            PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 180));

        header.graphics.drawImage(
            PdfBitmap(imageData.buffer
                .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes)),
            Rect.fromLTWH(0, 0, width, 180));

        // header.graphics.drawString(
        //   "FRM Bldg. Barangay San Miguel, Sto Tomas, Batangas",
        //   PdfStandardFont(PdfFontFamily.helvetica, 10,
        //       style: PdfFontStyle.regular),
        //   bounds: const Rect.fromLTWH(0, 25, 400, 20),
        //   brush: PdfSolidBrush(PdfColor.empty),
        // );
        // header.graphics.drawRectangle(
        //   bounds: Rect.fromLTWH(width - 148, 0, 148, 60),
        //   pen: PdfPen(PdfColor.fromCMYK(120, 12, 20, 20)),
        // );
        details.pdfDocumentTemplate.top = header;
      };
}
