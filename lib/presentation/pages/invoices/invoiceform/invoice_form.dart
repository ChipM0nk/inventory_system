import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';

import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/locator.dart';
import 'package:edar_app/presentation/pages/invoices/invoice_dialog.dart';
import 'package:edar_app/presentation/pages/invoices/invoice_item_table.dart';
import 'package:edar_app/presentation/pages/invoices/invoiceform/invoice_add_item_dialog.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/custom_label_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:edar_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/fields/custom_text_field.dart';

class InvoiceForm extends StatefulWidget {
  const InvoiceForm({Key? key}) : super(key: key);

  @override
  State<InvoiceForm> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final dateFormat = 'dd-MMM-yy';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    BlocProvider.of<InvoiceCubit>(context).init();
    BlocProvider.of<InvoiceCubit>(context).updatePaymentTerm('Cash');

    super.initState();
  }

  void _addItem(InvoiceItem invoiceItem) {
    BlocProvider.of<InvoiceCubit>(context).addInvoiceItem(invoiceItem);
  }

  void _deleteItem(InvoiceItem invoiceItem) {
    BlocProvider.of<InvoiceCubit>(context).removeInvoiceItem(invoiceItem);
  }

  @override
  Widget build(BuildContext context) {
    var invoiceNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).invoiceNumberStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context)
                    .updateInvoiceNumber(text);
              },
              labelText: 'Invoice No');
        });

    var customerName = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).customerNameStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context).updateCustomerName(text);
              },
              labelText: 'Customer Name');
        });
    var customerContactNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).customerContactStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context)
                    .updateCustomerContact(text);
              },
              labelText: 'Contact Number');
        });

    var customerAddressField = StreamBuilder<String>(
      stream: BlocProvider.of<InvoiceCubit>(context).customerAddressStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Customer Address",
            hintText: "Sto Tomas",
            textInputType: TextInputType.multiline,
            width: 465,
            minLines: 1,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<InvoiceCubit>(context)
                  .updateCustomerAddress(text);
            });
      },
    );

    var purchaseDate = Column(
      children: [
        CustomDatePicker(
          labelText: "Purchase Date",
          onChanged: (dateTime) {
            BlocProvider.of<InvoiceCubit>(context).updatePurchaseDate(dateTime);
          },
          dateFormat: dateFormat,
        ),
      ],
    );

    var paymentType = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).paymentTypeStream,
        builder: (context, snapshot) {
          void onPaymentTypeChange<String>(val) {
            BlocProvider.of<InvoiceCubit>(context).updatePaymentType(val);
          }

          return CustomDropdown<String>(
            labelText: "Payment Type",
            items: const [
              //TODO: Put in constant
              DropdownMenuItem<String>(
                value: 'Cash',
                child: Text('Cash'),
              ),
              DropdownMenuItem<String>(
                value: 'Cheque',
                child: Text('Cheque'),
              ),
            ],
            value: BlocProvider.of<InvoiceCubit>(context).getPaymentType(),
            context: context,
            onChanged: onPaymentTypeChange,
          );
        });

    var poNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).poNumberStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context).updatePoNumber(text);
              },
              labelText: 'PO Number');
        });

    var dueDate = CustomDatePicker(
      labelText: "Due Date",
      onChanged: (dateTime) {
        BlocProvider.of<InvoiceCubit>(context).updateDueDate(dateTime);
      },
      dateFormat: dateFormat,
    );

    var tinNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).tinNumberStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context).updateTinNumber(text);
              },
              labelText: 'TIN Number');
        });

    var paymentTerm = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).paymentTermStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context).updatePaymentTerm(text);
              },
              labelText: 'Payment Term');
        });

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<InvoiceCubit>(context).errorStream,
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
          print("Invoice Success"); //TODO create a popup for print
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              locator<NavigationService>().navigateTo(InvoiceFormRoute);
              BlocProvider.of<InvoiceCubit>(context).reset();
            });
          });
        }

        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 1000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        invoiceNumber,
                        customerName,
                        customerAddressField,
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customerContactNumber,
                        poNumber,
                        paymentType,
                        paymentTerm,
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tinNumber,
                        purchaseDate,
                        dueDate,
                        const SizedBox(width: 200),
                      ],
                    ),
                  ],
                ),
                StreamBuilder<List<InvoiceItem>>(
                    stream: BlocProvider.of<InvoiceCubit>(context)
                        .invoiceItemsStream,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: 1000,
                        child: Column(
                          children: [
                            InvoiceItemTable(
                              invoiceItems:
                                  BlocProvider.of<InvoiceCubit>(context)
                                      .getInvoiceItems(),
                              deleteInvoiceItem: _deleteItem,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: const Icon(
                                    Icons.add_box_outlined,
                                    color: Colors.green,
                                    size: 25,
                                  ),
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (_) {
                                          return MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(
                                                  value: context
                                                      .read<ProductsCubit>()),
                                              BlocProvider.value(
                                                  value: context
                                                      .read<InvoiceCubit>()),
                                            ],
                                            child: InvoiceAddItemDialog(
                                                addInvoiceItem: _addItem),
                                          );
                                        });
                                  },
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Total Amount: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      width: 120,
                                      child: StreamBuilder<double>(
                                        stream: BlocProvider.of<InvoiceCubit>(
                                                context)
                                            .totalAmountStream,
                                        builder: (context, snapshot) {
                                          final totalAmountController =
                                              TextEditingController();

                                          totalAmountController.text =
                                              snapshot.hasData
                                                  ? Util.convertToCurrency(
                                                          snapshot.data!)
                                                      .toString()
                                                  : "0.0";

                                          return SizedBox(
                                            height: 30,
                                            child: CustomLabelTextField(
                                              fontSize: 18,
                                              enabled: false,
                                              controller: totalAmountController,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                serviceErrorMessage,
                Row(
                  children: [
                    StreamBuilder<bool>(
                        stream:
                            BlocProvider.of<InvoiceCubit>(context).buttonValid,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: snapshot.hasData
                                ? () {
                                    _openInvoiceDialog();
                                  }
                                : null,
                            child: const Text("Review"),
                          );
                        }),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _openInvoiceDialog() {
    Invoice invoice = BlocProvider.of<InvoiceCubit>(context).getInvoice(null);
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<InvoiceCubit>(),
            child: InvoiceDialog(
              invoice: invoice,
              flgAddInvoice: true,
            ),
          );
        });
  }
}
