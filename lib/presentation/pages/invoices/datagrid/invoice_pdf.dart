import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class InvoicePdf {
  // final Invoice invoice;

  // InvoicePdf({required this.invoice});

  static makePdf(
      {required final Invoice invoice,
      String? invoiceNo,
      String? poNumber}) async {
    String docuInvoiceNo = invoice.invoiceNo ?? invoiceNo!;
    String docuPoNumber = invoice.poNumber ?? poNumber!;
    final imageLogo = MemoryImage(
        (await rootBundle.load('/images/edar_logo.jpg')).buffer.asUint8List());

    Widget paddedText(
      final String text, {
      final double padding = 5.0,
      final TextAlign align = TextAlign.left,
      final double fontSize = 12,
      final FontWeight fontWeight = FontWeight.normal,
      final FontStyle fontStyle = FontStyle.normal,
    }) =>
        Padding(
          padding:
              EdgeInsets.only(left: 5, right: 5, top: padding, bottom: padding),
          child: Text(text,
              textAlign: align,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  fontStyle: fontStyle)),
        );
    Widget labeledValueText({
      required final String label,
      required final String value,
      required final double labelWidth,
      required final double valueWidth,
    }) =>
        Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: labelWidth,
                      child: Text("$label: ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: PdfColors.black))),
                      width: valueWidth,
                      child: Text(value))
                ]));

    final pdf = Document();

    pdf.addPage(
      MultiPage(
        footer: (context) {
          return Stack(children: [
            Center(
              child: paddedText(
                  "$docuInvoiceNo :::: THIS SALES INVOICE SHALL BE VALID FOR FIVE (5) YEARS FROM THE DATE ATP",
                  fontWeight: FontWeight.bold,
                  align: TextAlign.center,
                  fontSize: 6),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: paddedText("${context.pageNumber}/${context.pagesCount}",
                    fontSize: 6, align: TextAlign.right))
          ]);
        },
        pageFormat: const PdfPageFormat(
            21.0 * PdfPageFormat.cm, 29.7 * PdfPageFormat.cm,
            marginTop: 1.0 * PdfPageFormat.cm,
            marginLeft: 1.0 * PdfPageFormat.cm,
            marginRight: 1.0 * PdfPageFormat.cm,
            marginBottom: 0.5 * PdfPageFormat.cm),
        build: (context) {
          var customerInfoArea = Container(
            height: 100,
            width: 350,
            padding: const EdgeInsets.all(10),
            decoration:
                BoxDecoration(border: Border.all(color: PdfColors.grey600)),
            child: Column(
              children: [
                labeledValueText(
                    label: "Customer",
                    value: invoice.customerName,
                    labelWidth: 80,
                    valueWidth: 250),
                labeledValueText(
                    label: "Address",
                    value: invoice.customerAddress ?? "",
                    labelWidth: 80,
                    valueWidth: 250),
                labeledValueText(
                    label: "Contact No",
                    value: invoice.contactNo ?? "",
                    labelWidth: 80,
                    valueWidth: 250),
                labeledValueText(
                    label: "TIN No",
                    value: invoice.tinNumber,
                    labelWidth: 80,
                    valueWidth: 250),
              ],
            ),
          );
          var invoiceInfoArea = Container(
            height: 135,
            width: 180,
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: PdfColors.grey600,
              ),
            ),
            child: Column(
              children: [
                Center(
                    child: Text("ORIGINAL",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Container(
                  width: 178,
                  height: 20,
                  color: PdfColors.green200,
                  child: Center(
                    child: Text(
                      "SALES INVOICE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: PdfColors.red),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Column(
                    children: [
                      labeledValueText(
                          label: "S.I. No",
                          value: docuInvoiceNo,
                          labelWidth: 68,
                          valueWidth: 100),
                      labeledValueText(
                          label: "Date",
                          value: invoice.purchaseDate.trim(),
                          labelWidth: 68,
                          valueWidth: 100),
                      labeledValueText(
                          label: "Terms",
                          value: invoice.paymentTerm.trim(),
                          labelWidth: 68,
                          valueWidth: 100),
                      labeledValueText(
                          label: "PO/DR.No",
                          value: docuPoNumber,
                          labelWidth: 68,
                          valueWidth: 100),
                    ],
                  ),
                ),
              ],
            ),
          );

          /**
             * For Testing large list
             */
          List<TableRow> paddingTableRow = <TableRow>[];
          int i = 0;
          while (i < 10 - invoice.invoiceItems.length) {
            i++;
            paddingTableRow.add(TableRow(children: [
              Text("  - "),
              Text("  - "),
              Text("  - "),
              Text("-  ", textAlign: TextAlign.right),
              Text("-  ", textAlign: TextAlign.right),
              Text("-  ", textAlign: TextAlign.right),
            ]));

            // ...invoice.invoiceItems.map((e) => TableRow(children: [
            //       paddedText(e.product.productCode, fontSize: 10),
            //       paddedText(e.product.productDescription, fontSize: 10),
            //       paddedText("${e.quantity.toString()} ${e.product.unit} ",
            //           fontSize: 10),
            //       paddedText(Util.convertToCurrency(e.price),
            //           align: TextAlign.right, fontSize: 10),
            //       paddedText(
            //           e.product.productPrice - e.price != 0.0
            //               ? Util.convertToCurrency(
            //                   e.product.productPrice - e.price)
            //               : "",
            //           align: TextAlign.right,
            //           fontSize: 10),
            //       paddedText(Util.convertToCurrency(e.totalAmount),
            //           align: TextAlign.right, fontSize: 10),
          }

          List<Widget> pdfBody = [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("EDAR CONSTRUCTION MATERIALS TRADING",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                        "FRM Bldg. Barangay San Miguel, Sto Tomas, Batangas \nContact No. 09165852926 (Globe) 09512441283 (TNT) \nVAT Reg: 168-755-162-000",
                        maxLines: 3,
                        style: const TextStyle(fontSize: 10)),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(imageLogo, height: 56, width: 100),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customerInfoArea,
                invoiceInfoArea,
              ],
            ),
            SizedBox(height: 20),
            Table(
              border: const TableBorder(
                bottom: BorderSide(style: BorderStyle.dotted),
                horizontalInside: BorderSide(style: BorderStyle.dotted),
                verticalInside: BorderSide(style: BorderStyle.solid),
              ),
              columnWidths: {
                0: const FixedColumnWidth(55),
                1: const FixedColumnWidth(155),
                2: const FixedColumnWidth(30),
                3: const FixedColumnWidth(50),
                4: const FixedColumnWidth(50),
                5: const FixedColumnWidth(60)
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: PdfColors.green200,
                    border: Border(
                      top: BorderSide(color: PdfColors.black),
                      bottom: BorderSide(color: PdfColors.black),
                    ),
                  ),
                  children: [
                    paddedText('ITEM CODE',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        fontSize: 10),
                    paddedText('DESCRIPTION',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        fontSize: 10),
                    paddedText('QTY UNIT',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        fontSize: 10),
                    paddedText('UNIT PRICE',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        fontSize: 10),
                    paddedText('DISCOUNT',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        fontSize: 9),
                    paddedText('TOTAL AMOUNT',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        fontSize: 10),
                  ],
                ),
                ...invoice.invoiceItems.map((e) => TableRow(children: [
                      paddedText(e.product.productCode, fontSize: 10),
                      paddedText(e.product.productDescription, fontSize: 10),
                      paddedText("${e.quantity.toString()} ${e.product.unit} ",
                          fontSize: 10),
                      paddedText(Util.convertToCurrency(e.product.productPrice),
                          align: TextAlign.right, fontSize: 10),
                      paddedText(
                          e.product.productPrice - e.price != 0.0
                              ? Util.convertToCurrency(
                                  (e.product.productPrice - e.price) *
                                      e.quantity)
                              : "-",
                          align: TextAlign.right,
                          fontSize: 10),
                      paddedText(Util.convertToCurrency(e.totalAmount),
                          align: TextAlign.right, fontSize: 10),
                    ])),
                ...paddingTableRow,
                TableRow(
                    decoration: const BoxDecoration(
                      color: PdfColors.black,
                    ),
                    children: [SizedBox(height: 3)]),
              ],
            ),
            Table(
                border: const TableBorder(
                  bottom: BorderSide(style: BorderStyle.dotted),
                  horizontalInside: BorderSide(style: BorderStyle.dotted),
                  verticalInside: BorderSide(style: BorderStyle.solid),
                ),
                children: [
                  TableRow(children: [
                    SizedBox(
                      width: 240,
                      height: 60,
                    ),
                    Table(
                        columnWidths: {0: const FixedColumnWidth(100)},
                        border: const TableBorder(
                          bottom: BorderSide(style: BorderStyle.dotted),
                          horizontalInside:
                              BorderSide(style: BorderStyle.dotted),
                          verticalInside: BorderSide(style: BorderStyle.solid),
                        ),
                        children: [
                          TableRow(children: [
                            paddedText("Total Amount",
                                padding: 1,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)
                          ]),
                          TableRow(children: [
                            paddedText("Less VAT", padding: 1, fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Amount Net of VAT",
                                padding: 1, fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Less SC/PWD Dsicount",
                                padding: 1, fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Amount Due", padding: 1, fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Add VAT", padding: 1, fontSize: 10)
                          ]),
                        ]),
                    Table(
                        columnWidths: {0: const FixedColumnWidth(60)},
                        border: const TableBorder(
                          bottom: BorderSide(style: BorderStyle.dotted),
                          horizontalInside:
                              BorderSide(style: BorderStyle.dotted),
                          verticalInside: BorderSide(style: BorderStyle.solid),
                        ),
                        children: [
                          TableRow(children: [
                            paddedText(
                                Util.convertToCurrency(invoice.totalAmount),
                                padding: 1,
                                fontSize: 12,
                                align: TextAlign.right,
                                fontWeight: FontWeight.bold)
                          ]),
                          TableRow(children: [
                            paddedText(
                                Util.convertToCurrency(
                                    invoice.totalAmount * .12),
                                padding: 1,
                                fontSize: 10,
                                align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText(
                                Util.convertToCurrency(
                                    invoice.totalAmount * .88),
                                padding: 1,
                                fontSize: 10,
                                align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText("0.00",
                                padding: 1,
                                fontSize: 10,
                                align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText("0.00",
                                padding: 1,
                                fontSize: 10,
                                align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText("0.00",
                                padding: 1,
                                fontSize: 10,
                                align: TextAlign.right)
                          ]),
                        ]),
                  ])
                ]),
            Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 0.5))),
                height: 20,
                alignment: Alignment.centerRight,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 330,
                          child: Text("TOTAL AMOUNT DUE",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold))),
                      SizedBox(width: 20),
                      SizedBox(
                          width: 110,
                          child: Text(
                              "PHP ${Util.convertToCurrency(invoice.totalAmount)}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)))
                    ])),
            SizedBox(height: 2),
            Container(
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: 0.5))),
            ),
            SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 150,
                    width: 180,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 10, right: 10, left: 30),
                        child: Column(children: [
                          paddedText(invoice.staff ?? "",
                              padding: 1,
                              fontSize: 10,
                              align: TextAlign.center),
                          Container(
                              width: 150,
                              decoration: const BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.5))),
                              child: paddedText("Sales Representative",
                                  padding: 1,
                                  fontSize: 10,
                                  align: TextAlign.center)),
                          SizedBox(height: 30),
                          Container(
                              width: 150,
                              decoration: const BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.5))),
                              child: paddedText("Checked by:",
                                  padding: 1,
                                  fontSize: 10,
                                  align: TextAlign.center)),
                        ]))),
                Container(
                    height: 90,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: PdfColors.grey600,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(children: [
                        paddedText("TERMS & CONDITION",
                            padding: 2,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            align: TextAlign.center),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: const TextStyle(fontSize: 7),
                                children: [
                                  const TextSpan(
                                      text:
                                          "Returns must strictly only be accepted within 30 days from invoice date. Purchased items for "),
                                  TextSpan(
                                      text: "return or exchange ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(
                                      text:
                                          "must be done strictly within 3 days from the day of invoice. Returns should be presented with its ORIGINAL INVOICE/RECEIPT and should be original packaging and in good condition."),
                                ])),
                      ]),
                    )),
                SizedBox(
                    height: 150,
                    width: 180,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 18, bottom: 10, left: 10, right: 30),
                        child: Column(children: [
                          Container(
                              width: 150,
                              decoration: const BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.5))),
                              child: paddedText("Customer over Printed Name",
                                  padding: 1,
                                  fontSize: 10,
                                  align: TextAlign.center)),
                          SizedBox(height: 15),
                          Container(
                              width: 150,
                              child: paddedText(
                                  "Recieved the above items in completely and good condition.",
                                  fontSize: 10,
                                  align: TextAlign.center,
                                  fontStyle: FontStyle.italic)),
                        ]))),
              ],
            ),
          ];
          print("Returning PDF body");

          return pdfBody;
        },
      ),
    );

    print("Opening print dialog");
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    // return pdf.save();
  }
}
