import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class ProformaPdf {
  static makePdf({
    required final Invoice invoice,
    String? invoiceNo,
    String? poNumber,
  }) async {
    String docuInvoiceNo = invoice.poNumber ?? poNumber!;
    final imageLogo = MemoryImage(
        (await rootBundle.load('/images/edar_logo.jpg')).buffer.asUint8List());

    List<InvoiceItem> invoiceItems = invoice.invoiceItems;

    double totalDiscount = 0.0;
    if (invoiceItems.isNotEmpty) {
      totalDiscount = invoiceItems
          .map((e) => (e.product.productPrice - e.totalAmount))
          .toList()
          .fold(0.0, (p, c) => p + c);
    }

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
          return Column(
            children: [
              Center(
                  child: paddedText(
                      "Should you have any inquiries and more info, please email us @ efrending14@gmail.com or visit to htttps://www.facebook.com/ef.ding.7",
                      fontStyle: FontStyle.italic,
                      fontSize: 7,
                      padding: 0)),
              Stack(
                children: [
                  Center(
                    child: paddedText(
                        "$docuInvoiceNo :::: THANK YOU FOR CHOOSING US TO DO YOUR BUSINESS",
                        align: TextAlign.center,
                        fontSize: 8),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: paddedText(
                          "${context.pageNumber}/${context.pagesCount}",
                          fontSize: 6,
                          align: TextAlign.right))
                ],
              ),
            ],
          );
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
                    label: "Sold To",
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
              ],
            ),
          );
          var invoiceInfoArea = Container(
            height: 135,
            width: 180,
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: PdfColors.grey600,
              ),
            ),
            child: Column(
              children: [
                Center(
                    child: Text("PURCHASE ORDER",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Column(
                    children: [
                      labeledValueText(
                          label: "PO No",
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
                          label: "Other",
                          value: "N/A",
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
          }

          var signatories = Container(
            margin: EdgeInsets.zero,
            height: 130,
            width: 540,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: PdfColors.grey600, style: BorderStyle.dotted),
            ),
            child: Column(
              children: [
                Container(
                  color: PdfColors.grey300,
                  margin: EdgeInsets.zero,
                  height: 20,
                  width: 536,
                  child: paddedText(
                    padding: 0,
                    "Received the above items completely in good condition",
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    align: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("_______________________"),
                        paddedText("Prepared by: ", fontSize: 10),
                        paddedText("Signature over Printed Name",
                            fontStyle: FontStyle.italic,
                            padding: 0,
                            fontSize: 10),
                      ],
                    ),
                    Column(
                      children: [
                        Text("_______________________"),
                        paddedText("Checked by: ", fontSize: 10),
                        paddedText("Signature over Printed Name",
                            fontStyle: FontStyle.italic,
                            padding: 0,
                            fontSize: 10),
                      ],
                    ),
                    Column(
                      children: [
                        Text("_______________________"),
                        paddedText("Recieved by: ", fontSize: 10),
                        paddedText("Signature over Printed Name",
                            fontStyle: FontStyle.italic,
                            padding: 0,
                            fontSize: 10),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
          var detailsTable = Table(
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
                                (e.product.productPrice - e.price) * e.quantity)
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
          );

          var proformaDetailsTable = Table(
            border: const TableBorder(
              bottom: BorderSide(style: BorderStyle.solid),
              horizontalInside: BorderSide(style: BorderStyle.solid),
              verticalInside: BorderSide(style: BorderStyle.solid),
            ),
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
                  paddedText('CONTACT PERSON',
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                      fontSize: 8),
                  paddedText('SHIPPING METHOD',
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                      fontSize: 8),
                  paddedText('DELIVERY DATE',
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                      fontSize: 8),
                  paddedText('DELIVERY NO.',
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                      fontSize: 8),
                  paddedText('DELIVERED BY',
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                      fontSize: 8),
                  paddedText('DUE DATE',
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                      fontSize: 8),
                ],
              ),
              TableRow(children: [
                paddedText(invoice.proforma?.contactPerson ?? "", fontSize: 10),
                paddedText(invoice.proforma?.shippingMethod ?? "",
                    fontSize: 10),
                paddedText(invoice.proforma?.deliveryDate ?? "", fontSize: 10),
                paddedText(invoice.proforma?.deliveredBy ?? "", fontSize: 10),
                paddedText(invoice.proforma?.deliveryNo ?? "", fontSize: 10),
                paddedText(invoice.proforma?.dueDate ?? "", fontSize: 10),
              ]),
            ],
          );
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
            SizedBox(height: 10),
            proformaDetailsTable,
            SizedBox(height: 10),
            detailsTable,
            Table(
                border: const TableBorder(
                  bottom: BorderSide(style: BorderStyle.dotted),
                  horizontalInside: BorderSide(style: BorderStyle.dotted),
                  verticalInside: BorderSide(style: BorderStyle.solid),
                ),
                children: [
                  TableRow(children: [
                    Table(columnWidths: {
                      0: const FixedColumnWidth(240)
                    }, children: [
                      TableRow(children: [paddedText(" ", fontSize: 8)]),
                      TableRow(children: [
                        paddedText(
                          "REMARKS / INSTRUCTION",
                          padding: 1,
                          fontSize: 12,
                          align: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        )
                      ]),
                      TableRow(children: [paddedText(" ", fontSize: 12)]),
                      TableRow(children: [
                        paddedText(
                            "1) This price is valid 7 Days from the date of quotation.",
                            padding: 1,
                            fontSize: 10,
                            align: TextAlign.left,
                            fontStyle: FontStyle.italic)
                      ]),
                      TableRow(children: [
                        paddedText(
                            "2) No return no exchange the item after 7 days & w/o Reciept.",
                            padding: 1,
                            fontSize: 10,
                            align: TextAlign.left,
                            fontStyle: FontStyle.italic)
                      ]),
                      TableRow(children: [
                        paddedText(
                            "3) The Purchase No is not the Invoice number.",
                            padding: 1,
                            fontSize: 10,
                            align: TextAlign.left,
                            fontStyle: FontStyle.italic)
                      ]),
                    ]),
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
                            paddedText("Discount Amount",
                                padding: 1, fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Down Payment", padding: 1, fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Others", padding: 1, fontSize: 10)
                          ]),
                          TableRow(children: [
                            paddedText("Delivery Fee", padding: 1, fontSize: 10)
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
                            paddedText(Util.convertToCurrency(totalDiscount),
                                padding: 1,
                                fontSize: 10,
                                align: TextAlign.right)
                          ]),
                          TableRow(children: [
                            paddedText(
                                Util.convertToCurrency(invoice.downPayment),
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
                          width: 400,
                          child: Text("TOTAL AMOUNT DUE",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold))),
                      SizedBox(width: 20),
                      SizedBox(
                          width: 110,
                          child: Text(
                              "PHP ${Util.convertToCurrency(invoice.totalAmount - (invoice.downPayment ?? 0.00))}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)))
                    ])),
            SizedBox(height: 2),
            Container(
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: 0.5))),
            ),
            SizedBox(height: 10),
            signatories,
          ];

          return pdfBody;
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
