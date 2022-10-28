import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/presentation/pages/invoices/datagrid/invoice_item_datagrid.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/custom_inline_label.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InvoiceDialog extends StatelessWidget {
  final Invoice invoice;
  final int? fontSize;
  final bool flgAddInvoice;
  const InvoiceDialog(
      {required this.invoice,
      this.fontSize = 10,
      this.flgAddInvoice = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    var stackHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(cells: [
        StackedHeaderCell(
            columnNames: ['prodname', 'proddesc', 'price', 'qty', 'total'],
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
                              label: "Purchase Date: ",
                              value: invoice.purchaseDate),
                          CustomInlineLabel(
                              label: "Due Date: ", value: invoice.dueDate),
                        ]),
                        Row(children: [
                          CustomInlineLabel(
                              width: 600,
                              label: "Remarks: ",
                              value: invoice.remarks),
                        ])
                      ],
                    )
                  ],
                ),
              ),
            ))
      ]),
    ];

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<InvoiceCubit>(context).errorStream,
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
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceAdded) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        return AlertDialog(
          title: const Text("Invoice Details"),
          content: Column(
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
          actionsPadding: const EdgeInsets.only(bottom: 40),
          actions: [
            Center(
              child: SizedBox(
                width: 170,
                height: 70,
                child: CustomElevatedButton(
                  onPressed: flgAddInvoice
                      ? () {
                          BlocProvider.of<InvoiceCubit>(context).addInvoice();
                        }
                      : () {},
                  child: Center(
                    child: Text(
                      flgAddInvoice ? "SUBMIT" : "PRINT",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
