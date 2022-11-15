import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class InvoicePdf {
  final Invoice invoice;

  InvoicePdf({required this.invoice});

  Widget paddedText(
    final String text, {
    final TextAlign align = TextAlign.left,
    final double fontSize = 12,
    final FontWeight fontWeight = FontWeight.normal,
  }) =>
      Padding(
        padding: const EdgeInsets.all(5),
        child: Text(text,
            textAlign: align,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
      );
  Widget labeledValueText({
    required final String label,
    required final String value,
    required final double labelWidth,
    required final double valueWidth,
  }) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
                width: labelWidth,
                child: Text("$label: ",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: PdfColors.black))),
                width: valueWidth,
                child: Text(value))
          ]));

  void makePdf() async {
    final imageLogo = MemoryImage(
        (await rootBundle.load('/images/edar_logo.jpg')).buffer.asUint8List());
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          var customerInfoArea = Container(
            height: 100,
            width: 310,
            padding: const EdgeInsets.all(10),
            decoration:
                BoxDecoration(border: Border.all(color: PdfColors.grey600)),
            child: Column(
              children: [
                labeledValueText(
                    label: "Customer",
                    value: invoice.customerName,
                    labelWidth: 80,
                    valueWidth: 210),
                labeledValueText(
                    label: "Address",
                    value: invoice.customerAddress ?? "",
                    labelWidth: 80,
                    valueWidth: 210),
                labeledValueText(
                    label: "Contact No",
                    value: invoice.contactNo ?? "",
                    labelWidth: 80,
                    valueWidth: 210),
                labeledValueText(
                    label: "TIN No",
                    value: invoice.tinNumber,
                    labelWidth: 80,
                    valueWidth: 210),
              ],
            ),
          );
          var invoiceInfoArea = Container(
            height: 135,
            width: 160,
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
                  width: 158,
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
                          value: invoice.invoiceNo,
                          labelWidth: 68,
                          valueWidth: 80),
                      labeledValueText(
                          label: "Date",
                          value: invoice.purchaseDate,
                          labelWidth: 68,
                          valueWidth: 80),
                      labeledValueText(
                          label: "Terms",
                          value: invoice.paymentTerm,
                          labelWidth: 68,
                          valueWidth: 80),
                      labeledValueText(
                          label: "PO/DR.No",
                          value: invoice.poNumber,
                          labelWidth: 68,
                          valueWidth: 80),
                    ],
                  ),
                ),
              ],
            ),
          );

          /**
             * For Testing large list
             */
          // List<TableRow> ret = <TableRow>[];
          // int i = 1;
          // while (i < 8) {
          //   i++;
          //   ret.addAll([
          //     ...invoice.invoiceItems.map((e) => TableRow(children: [
          //           paddedText(e.product.productCode),
          //           paddedText(e.product.productDescription),
          //           paddedText("${e.quantity.toString()} ${e.product.unit} "),
          //           paddedText(Util.convertToCurrency(e.price),
          //               align: TextAlign.right),
          //           paddedText(Util.convertToCurrency(e.totalAmount),
          //               align: TextAlign.right),
          //         ]))
          //   ]);
          // }

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
                0: const FixedColumnWidth(70),
                1: const FixedColumnWidth(150),
                2: const FixedColumnWidth(40),
                3: const FixedColumnWidth(60),
                4: const FixedColumnWidth(80)
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
                        fontWeight: FontWeight.bold, align: TextAlign.center),
                    paddedText('DESCRIPTION',
                        fontWeight: FontWeight.bold, align: TextAlign.center),
                    paddedText('QTY UNIT',
                        fontWeight: FontWeight.bold, align: TextAlign.center),
                    paddedText('UNIT PRICE',
                        fontWeight: FontWeight.bold, align: TextAlign.center),
                    paddedText('TOTAL AMOUNT',
                        fontWeight: FontWeight.bold, align: TextAlign.center),
                  ],
                ),
                // ...ret,
                ...invoice.invoiceItems.map((e) => TableRow(children: [
                      paddedText(e.product.productCode),
                      paddedText(e.product.productDescription),
                      paddedText("${e.quantity.toString()} ${e.product.unit} "),
                      paddedText(Util.convertToCurrency(e.price),
                          align: TextAlign.right),
                      paddedText(Util.convertToCurrency(e.totalAmount),
                          align: TextAlign.right),
                    ])),
                TableRow(
                    decoration: BoxDecoration(
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
                    SizedBox(width: 220, height: 60, child: Text("Hello")),
                    Table(
                        columnWidths: {0: FixedColumnWidth(100)},
                        border: const TableBorder(
                          bottom: BorderSide(style: BorderStyle.dotted),
                          horizontalInside:
                              BorderSide(style: BorderStyle.dotted),
                          verticalInside: BorderSide(style: BorderStyle.solid),
                        ),
                        children: [
                          TableRow(children: [
                            paddedText("Total Amount",
                                fontSize: 12, fontWeight: FontWeight.bold)
                          ]),
                          TableRow(
                              children: [paddedText("Less VAT", fontSize: 10)]),
                          TableRow(children: [
                            paddedText("Amount Net of VAT", fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Less SC/PWD Dsicount", fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Amount Due", fontSize: 10)
                          ]),
                          TableRow(
                              children: [paddedText("Add VAT", fontSize: 10)]),
                        ]),
                    Table(
                        columnWidths: {0: FixedColumnWidth(80)},
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
                                fontSize: 12,
                                align: TextAlign.right,
                                fontWeight: FontWeight.bold)
                          ]),
                          TableRow(children: [
                            paddedText(
                                Util.convertToCurrency(
                                    invoice.totalAmount * .12),
                                fontSize: 10,
                                align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText(
                                Util.convertToCurrency(
                                    invoice.totalAmount * .88),
                                fontSize: 10,
                                align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText("0.00",
                                fontSize: 10, align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText("0.00",
                                fontSize: 10, align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText("0.00",
                                fontSize: 10, align: TextAlign.right)
                          ]),
                        ]),
                  ])
                ])
          ];
          return pdfBody;
        },
      ),
    );
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    // return pdf.save();
  }
}
