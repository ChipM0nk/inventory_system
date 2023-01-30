import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/invoice/save_invoice_cubit.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/presentation/pages/invoices/datagrid/invoice_item_datagrid.dart';
import 'package:edar_app/reports/invoice_pdf.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_action_button.dart';
import 'package:edar_app/presentation/widgets/custom_inline_label.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/reports/proforma_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:math' as math;

class InvoiceDialog extends StatelessWidget {
  final Invoice invoice;
  final int? fontSize;
  final bool flgAddInvoice;
  final bool isProforma;
  const InvoiceDialog({
    required this.invoice,
    this.fontSize = 10,
    this.flgAddInvoice = false,
    this.isProforma = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double buttonFooterWidth =
        170 + (!flgAddInvoice ? 180 : 0) + (isProforma ? 180 : 0);

    List<Widget> proformaHeaders = [
      'CONTACT PERSON',
      'SHIPPING METHOD',
      'DELIVERY DATE',
      'DELIVERY NO',
      'DELIVERED BY',
      'DUE DATE'
    ]
        .map(
          (e) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              e,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        )
        .toList();

    List<Widget> proformaDetails = [
      invoice.proforma?.contactPerson ?? "",
      invoice.proforma?.shippingMethod ?? "",
      invoice.proforma?.deliveryDate ?? "",
      invoice.proforma?.deliveryNo ?? "",
      invoice.proforma?.deliveredBy ?? "",
      invoice.proforma?.dueDate ?? "",
    ]
        .map(
          (e) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              e,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        )
        .toList();
    var stackHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(
        cells: [
          StackedHeaderCell(
            columnNames: [
              'Product Code',
              'Product Name',
              'Product Description',
              'Price',
              'QTY',
              'Total'
            ],
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CustomInlineLabel(
                              label: "Invoice No: ", value: invoice.invoiceNo),
                          CustomInlineLabel(
                              label: "PO Number: ", value: invoice.poNumber),
                        ]),
                        Row(children: [
                          CustomInlineLabel(
                              label: "Customer Name: ",
                              value: invoice.customerName),
                          CustomInlineLabel(
                              width: 600,
                              label: "Customer Address: ",
                              value: invoice.customerAddress),
                        ]),
                        Row(children: [
                          CustomInlineLabel(
                              label: "Contact No: ", value: invoice.contactNo),
                          CustomInlineLabel(
                              label: "TIN Number: ", value: invoice.tinNumber),
                        ]),
                        Row(children: [
                          CustomInlineLabel(
                              label: "Payment Type: ",
                              value: invoice.paymentType),
                          CustomInlineLabel(
                              label: "Payment Term: ",
                              value: invoice.paymentTerm),
                        ]),
                        Row(children: [
                          CustomInlineLabel(
                              label: "Invoice Date: ",
                              value: invoice.purchaseDate),
                          isProforma
                              ? CustomInlineLabel(
                                  label: "Down Payment: ",
                                  value:
                                      'PHP ${Util.convertToCurrency(invoice.downPayment ?? 0.00).toString()}')
                              : const SizedBox(width: 0),
                        ]),
                        Row(children: [
                          CustomInlineLabel(
                              width: 600,
                              label: "Remarks: ",
                              value: invoice.remarks),
                        ]),
                        isProforma
                            ? Table(
                                border: TableBorder.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                                columnWidths: const {
                                  0: FixedColumnWidth(190),
                                  1: FixedColumnWidth(190),
                                  2: FixedColumnWidth(150),
                                  3: FixedColumnWidth(150),
                                  4: FixedColumnWidth(150),
                                  5: FixedColumnWidth(150),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                    ),
                                    children: proformaHeaders,
                                  ),
                                  TableRow(children: proformaDetails)
                                ],
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ];

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<SaveInvoiceCubit>(context).errorStream,
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ErrorMessage(
                  snapshot: snapshot,
                  fontSize: 14,
                  height: 20,
                ),
              )
            : const SizedBox();
      },
    );
    return BlocBuilder<SaveInvoiceCubit, SaveInvoiceState>(
      builder: (context, state) {
        bool isSaving = state is InvoiceSaving;
        bool isVoiding = state is InvoiceVoiding;
        if (state is InvoiceVoided ||
            state is InvoiceSaved ||
            state is InvoiceFinalized) {
          Future.delayed(Duration.zero, () {
            print("State is $state");
            if (state is InvoiceVoided) {
              BlocProvider.of<InvoiceCubit>(context).fetchInvoices();
            } else if (state is InvoiceSaved) {
              String invoiceNo = state.invoiceNo!;
              String poNumber = state.poNumber!;
              InvoicePdf.makePdf(
                  invoice: invoice, invoiceNo: invoiceNo, poNumber: poNumber);
            } else {
              BlocProvider.of<InvoiceCubit>(context).fetchInvoices();
              InvoicePdf.makePdf(invoice: invoice);
            }
            Navigator.of(context, rootNavigator: true).pop();
          });
        }

        final GlobalKey<SfDataGridState> invoiceSfKey =
            GlobalKey<SfDataGridState>();

        // void exportDataGridToPDF() async {
        //   print("Opening PDF Print Dialog");
        //   Future<Uint8List> docByte = InvoicePdf.makePdf(invoice);
        //   await Printing.layoutPdf(onLayout: (_) => docByte);
        // }

        return AlertDialog(
          title: Text("Invoice Details${isProforma ? " (PROFORMA)" : ""}"),
          content: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 1000,
                    height: 540,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 500,
                          child: InvoiceItemDataGrid(
                            invoiceSfKey: invoiceSfKey,
                            invoiceItems: invoice.invoiceItems,
                            summaryTotal: invoice.totalAmount,
                            stackHeaderRows: stackHeaderRows,
                            editable: false,
                          ),
                        ),
                        serviceErrorMessage,
                      ],
                    ),
                  ),
                ],
              ),
              if (invoice.trxnStatus == 'VOID')
                Center(
                  child: Transform.rotate(
                    angle: -math.pi / 4,
                    child: Text(
                      "VOID",
                      style:
                          TextStyle(fontSize: 120, color: Colors.red.shade300),
                    ),
                  ),
                ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(bottom: 40),
          actions: [
            Center(
              child: SizedBox(
                width: buttonFooterWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (invoice.trxnStatus != 'VOID')
                      SizedBox(
                        width: 170,
                        height: 70,
                        child: CustomElevatedActionButton(
                          onPressed: flgAddInvoice
                              ? () async {
                                  BlocProvider.of<SaveInvoiceCubit>(context)
                                      .addInvoice();
                                }
                              : () async {
                                  await InvoicePdf.makePdf(invoice: invoice);
                                },
                          text: Text(
                            flgAddInvoice ? "SUBMIT" : "PRINT",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          icon: Icon(flgAddInvoice ? Icons.save : Icons.print),
                          isLoading: isSaving,
                        ),
                      ),
                    if (isProforma &&
                        invoice.trxnStatus != 'VOID' &&
                        !flgAddInvoice)
                      SizedBox(
                        width: 170,
                        height: 70,
                        child: CustomElevatedActionButton(
                          color: Colors.blue.shade600,
                          onPressed: invoice.trxnStatus == 'PROFORMA'
                              ? () {
                                  finalizeInvoice(context);
                                }
                              : () async {
                                  await ProformaPdf.makePdf(invoice: invoice);
                                },
                          isLoading: isSaving,
                          text: Text(
                            invoice.trxnStatus == 'PROFORMA'
                                ? "FINALIZE"
                                : "PRINT PF",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          icon: Icon(
                            invoice.trxnStatus == 'PROFORMA'
                                ? Icons.done_all_outlined
                                : Icons.close,
                            size: 25,
                          ),
                        ),
                      ),
                    if (!flgAddInvoice && invoice.trxnStatus != 'VOID')
                      SizedBox(
                        width: 170,
                        height: 70,
                        child: CustomElevatedActionButton(
                          color: Colors.red.shade600,
                          onPressed: invoice.trxnStatus != 'VOID'
                              ? () {
                                  voidInvoice(context);
                                }
                              : null,
                          isLoading: isVoiding,
                          text: const Text(
                            "VOID",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          icon: const Icon(
                            Icons.close,
                            size: 25,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void voidInvoice(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<SaveInvoiceCubit>(),
            child: AlertDialog(
              title: const Text("Void Invoice"),
              content:
                  const Text("Are you sure you want to void this invoice?"),
              actions: [
                ElevatedButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      BlocProvider.of<SaveInvoiceCubit>(context)
                          .voidInvoice(invoice.invoiceId!);
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
                ElevatedButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
              ],
            ),
          );
        });
  }

  void finalizeInvoice(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<SaveInvoiceCubit>(),
            child: AlertDialog(
              title: const Text("Finalize Invoice"),
              content:
                  const Text("Are you sure you want to finalize this invoice?"),
              actions: [
                ElevatedButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      BlocProvider.of<SaveInvoiceCubit>(context)
                          .finalizeInvoice(invoice.invoiceId!);
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
                ElevatedButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
              ],
            ),
          );
        });
  }
}
