import 'package:edar_app/constants/text_field_formats.dart';
import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/invoice/save_invoice_cubit.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';

import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/locator.dart';
import 'package:edar_app/presentation/pages/invoices/datagrid/invoice_item_datagrid.dart';
import 'package:edar_app/presentation/pages/invoices/invoice_dialog.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:edar_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
    BlocProvider.of<SaveInvoiceCubit>(context).init();
    BlocProvider.of<SaveInvoiceCubit>(context).updatePaymentTerm('Cash');

    super.initState();
  }

  void _addItem(InvoiceItem invoiceItem) {
    BlocProvider.of<SaveInvoiceCubit>(context).addInvoiceItem(invoiceItem);
  }

  void _deleteItem(InvoiceItem invoiceItem) {
    BlocProvider.of<SaveInvoiceCubit>(context).removeInvoiceItem(invoiceItem);
  }

  bool isProforma = false;
  String invoiceTypeVal = 'Normal';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveInvoiceCubit, SaveInvoiceState>(
      builder: (context, state) {
        if (state is InvoiceSaved) {
          Future.delayed(Duration.zero, () {
            // setState(() {
            locator<NavigationService>().navigateTo(InvoiceFormRoute);
            BlocProvider.of<SaveInvoiceCubit>(context).initDialog();
            // });
          });
        }

        var invoiceType = CustomDropdown(
          labelText: "Invoice Type",
          context: context,
          value: invoiceTypeVal,
          items: const [
            DropdownMenuItem<String>(
              value: 'Normal',
              child: Text('Normal'),
            ),
            DropdownMenuItem<String>(
              value: 'Proforma',
              child: Text('Proforma'),
            ),
          ],
          onChanged: (value) {
            setState(
              () {
                isProforma = value == 'Proforma';
                invoiceTypeVal = value;
                BlocProvider.of<SaveInvoiceCubit>(context)
                    .updateTrxnStatus(isProforma ? 'PROFORMA' : 'FINAL');
                BlocProvider.of<SaveInvoiceCubit>(context)
                    .updateInvoiceType(value);
              },
            );
          },
        );
        var customerName = StreamBuilder<String>(
            stream:
                BlocProvider.of<SaveInvoiceCubit>(context).customerNameStream,
            builder: (context, snapshot) {
              return CustomTextField(
                  snapshot: snapshot,
                  onChanged: (text) {
                    BlocProvider.of<SaveInvoiceCubit>(context)
                        .updateCustomerName(text);
                  },
                  labelText: 'Customer Name');
            });
        var customerContactNumber = StreamBuilder<String>(
            stream: BlocProvider.of<SaveInvoiceCubit>(context)
                .customerContactStream,
            builder: (context, snapshot) {
              return CustomTextField(
                  snapshot: snapshot,
                  onChanged: (text) {
                    BlocProvider.of<SaveInvoiceCubit>(context)
                        .updateCustomerContact(text);
                  },
                  labelText: 'Contact Number');
            });

        var customerAddressField = StreamBuilder<String>(
          stream:
              BlocProvider.of<SaveInvoiceCubit>(context).customerAddressStream,
          builder: (context, snapshot) {
            return CustomTextField(
                labelText: "Customer Address",
                hintText: "Sto Tomas",
                textInputType: TextInputType.multiline,
                width: 465,
                minLines: 1,
                snapshot: snapshot,
                onChanged: (text) {
                  BlocProvider.of<SaveInvoiceCubit>(context)
                      .updateCustomerAddress(text);
                });
          },
        );

        var purchaseDate = CustomDatePicker(
          labelText: "Purchase Date",
          onChanged: (dateTime) {
            BlocProvider.of<SaveInvoiceCubit>(context)
                .updatePurchaseDate(dateTime);
          },
          dateFormat: dateFormat,
        );

        var paymentType = StreamBuilder<String>(
            stream:
                BlocProvider.of<SaveInvoiceCubit>(context).paymentTypeStream,
            builder: (context, snapshot) {
              void onPaymentTypeChange<String>(val) {
                BlocProvider.of<SaveInvoiceCubit>(context)
                    .updatePaymentType(val);
              }

              return CustomDropdown<String>(
                labelText: "Payment Type",
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Cash',
                    child: Text('Cash'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'GCash',
                    child: Text('GCash'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Bank Transfer',
                    child: Text('Bank Transfer'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Debit Card',
                    child: Text('Debit Card'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'PayMaya',
                    child: Text('PayMaya'),
                  ),
                ],
                value:
                    BlocProvider.of<SaveInvoiceCubit>(context).getPaymentType(),
                context: context,
                onChanged: onPaymentTypeChange,
              );
            });

        var tinNumber = StreamBuilder<String>(
            stream: BlocProvider.of<SaveInvoiceCubit>(context).tinNumberStream,
            builder: (context, snapshot) {
              return CustomTextField(
                  snapshot: snapshot,
                  onChanged: (text) {
                    BlocProvider.of<SaveInvoiceCubit>(context)
                        .updateTinNumber(text);
                  },
                  labelText: 'TIN Number');
            });

        var paymentTerm = StreamBuilder<String>(
            stream:
                BlocProvider.of<SaveInvoiceCubit>(context).paymentTermStream,
            builder: (context, snapshot) {
              return CustomTextField(
                  snapshot: snapshot,
                  onChanged: (text) {
                    BlocProvider.of<SaveInvoiceCubit>(context)
                        .updatePaymentTerm(text);
                  },
                  labelText: 'Payment Term');
            });

        var remarks = StreamBuilder<String>(
            stream: BlocProvider.of<SaveInvoiceCubit>(context).remarksStream,
            builder: (context, snapshot) {
              return CustomTextField(
                  snapshot: snapshot,
                  width: 465,
                  onChanged: (text) {
                    BlocProvider.of<SaveInvoiceCubit>(context)
                        .updateRemarks(text);
                  },
                  labelText: 'Remarks');
            });

        var deliveredBy = StreamBuilder<String>(
            stream:
                BlocProvider.of<SaveInvoiceCubit>(context).deliveredByStream,
            builder: (context, snapshot) {
              return CustomTextField(
                  snapshot: snapshot,
                  onChanged: (text) {
                    BlocProvider.of<SaveInvoiceCubit>(context)
                        .updateDeliveredBy(text);
                  },
                  labelText: 'Delivered By');
            });
        var contactPerson = StreamBuilder<String>(
            stream:
                BlocProvider.of<SaveInvoiceCubit>(context).contactPersonStream,
            builder: (context, snapshot) {
              return CustomTextField(
                  snapshot: snapshot,
                  onChanged: (text) {
                    BlocProvider.of<SaveInvoiceCubit>(context)
                        .updateContactPerson(text);
                  },
                  labelText: 'Contact Person');
            });
        var shippingMethod = StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return CustomDropdown(
                value: BlocProvider.of<SaveInvoiceCubit>(context)
                    .getShippingMethod(),
                width: 150,
                labelText: "Shipping Status",
                context: context,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Pick-up',
                    child: Text('Pick-up'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Delivery',
                    child: Text('Delivery'),
                  ),
                ],
                onChanged: (value) {
                  BlocProvider.of<SaveInvoiceCubit>(context)
                      .updateShippingMethod(value);
                },
              );
            });

        var dueDate = CustomDatePicker(
          width: 150,
          labelText: "Due Date",
          initialValue: "",
          onChanged: (dateTime) {
            BlocProvider.of<SaveInvoiceCubit>(context).updateDueDate(dateTime);
          },
          dateFormat: dateFormat,
        );
        var deliveryDate = CustomDatePicker(
          width: 150,
          labelText: "Delivery Date",
          initialValue: "",
          onChanged: (dateTime) {
            BlocProvider.of<SaveInvoiceCubit>(context)
                .updateDeliveryDate(dateTime);
          },
          dateFormat: dateFormat,
        );

        var downpayment = Offstage(
          offstage: !isProforma,
          child: StreamBuilder<double>(
              stream:
                  BlocProvider.of<SaveInvoiceCubit>(context).downPaymentStream,
              builder: (context, snapshot) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        TextFieldFormat.amountFormat
                      ],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: "0.00",
                        labelText: 'Down Payment',
                        labelStyle: TextStyle(
                          color: Colors.green.shade900,
                        ),
                        filled: true,
                        fillColor: Colors.green.shade50,
                      ),
                      onChanged: (value) => {
                        BlocProvider.of<SaveInvoiceCubit>(context)
                            .updateDownPayment(value)
                      },
                    ),
                  ),
                );
              }),
        );

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
                        // invoiceNumber,
                        invoiceType,
                        customerName,
                        customerAddressField,
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customerContactNumber,
                        tinNumber,
                        paymentType,
                        paymentTerm,
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        purchaseDate,
                        remarks,
                        const SizedBox(
                          width: 200,
                        ),
                      ],
                    ),
                    Offstage(
                      offstage: !isProforma,
                      child: Column(
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              deliveredBy,
                              contactPerson,
                              shippingMethod,
                              dueDate,
                              deliveryDate,
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                StreamBuilder<List<InvoiceItem>>(
                    stream: BlocProvider.of<SaveInvoiceCubit>(context)
                        .invoiceItemsStream,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: 1000,
                        height: 370,
                        child: Column(
                          children: [
                            InvoiceItemDataGrid(
                              invoiceSfKey: GlobalKey<SfDataGridState>(),
                              invoiceItems:
                                  BlocProvider.of<SaveInvoiceCubit>(context)
                                      .getInvoiceItems(),
                              summaryTotal:
                                  BlocProvider.of<SaveInvoiceCubit>(context)
                                      .getTotal(), //TO Update
                              editable: true,
                              addInvoiceItem: _addItem,
                              deleteInvoiceItem: _deleteItem,
                            ),
                            downpayment,
                          ],
                        ),
                      );
                    }),
                Align(
                  alignment: Alignment.topRight,
                  child: StreamBuilder<bool>(
                      stream: BlocProvider.of<SaveInvoiceCubit>(context)
                          .buttonValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          height: 50,
                          width: 150,
                          child: CustomElevatedButton(
                            onPressed: snapshot.hasData
                                ? () {
                                    _openInvoiceDialog();
                                  }
                                : null,
                            child: const Text("REVIEW",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _openInvoiceDialog() {
    Invoice invoice = BlocProvider.of<SaveInvoiceCubit>(context).getInvoice();
    BlocProvider.of<SaveInvoiceCubit>(context).clearError();
    showDialog(
        context: context,
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<InvoiceCubit>()),
              BlocProvider.value(value: context.read<SaveInvoiceCubit>()),
            ],
            child: InvoiceDialog(
              invoice: invoice,
              flgAddInvoice: true,
              isProforma: isProforma,
            ),
          );
        });
  }
}
