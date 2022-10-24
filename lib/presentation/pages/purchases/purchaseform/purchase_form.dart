import 'package:edar_app/constants/text_field_formats.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/pages/purchases/purchase_item_table.dart';
import 'package:edar_app/presentation/pages/purchases/purchaseform/add_purchase_item_dialog.dart';

import 'package:edar_app/presentation/utils/util.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
import 'package:edar_app/presentation/widgets/fields/custom_label_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:edar_app/services/navigation_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator.dart';
import '../../../widgets/fields/custom_text_field.dart';

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({Key? key}) : super(key: key);

  @override
  State<PurchaseForm> createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  final dateFormat = 'dd-MMM-yy';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    BlocProvider.of<PurchaseCubit>(context).init();
    BlocProvider.of<SuppliersCubit>(context).fetchSuppliers();
    super.initState();
  }

  void _addItem(PurchaseItem purchaseItem) {
    BlocProvider.of<PurchaseCubit>(context).addPurchaseItem(purchaseItem);
  }

  void _deleteItem(PurchaseItem purchaseItem) {
    BlocProvider.of<PurchaseCubit>(context).removePurchaseItem(purchaseItem);
  }

  @override
  Widget build(BuildContext context) {
    var purchaseNo = StreamBuilder<String>(
        stream: BlocProvider.of<PurchaseCubit>(context).purchaseNoStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<PurchaseCubit>(context).updatePurchaseNo(text);
              },
              labelText: 'Purchase No');
        });
    var batchCode = StreamBuilder<String>(
        stream: BlocProvider.of<PurchaseCubit>(context).batchCodeStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              hintText: "2022-09-12", //TODO review
              inputFormatters: [
                TextFieldFormat.bacthCodeFormat,
              ],
              onChanged: (text) {
                BlocProvider.of<PurchaseCubit>(context).updateBatchCode(text);
              },
              labelText: 'Batch Code');
        });
    var purchaseDate = Column(
      children: [
        CustomDatePicker(
          labelText: "Purchase Date",
          onChanged: (dateTime) {
            BlocProvider.of<PurchaseCubit>(context)
                .updatePurchaseDate(dateTime);
          },
          dateFormat: dateFormat,
        ),
      ],
    );

    var supplierFinderField = StreamBuilder<Object>(
        stream: BlocProvider.of<PurchaseCubit>(context).supplierStream,
        builder: (context, snapshot) {
          return BlocBuilder<SuppliersCubit, SuppliersState>(
            builder: (context, state) {
              if (state is SuppliersLoaded) {
                return Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      BlocProvider.of<PurchaseCubit>(context)
                          .updateSupplier(null);
                      return const Iterable<String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      matches.addAll(
                          state.suppliers.map((e) => e.supplierName).toList());

                      matches.retainWhere((s) {
                        return s
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                      if (matches.isEmpty) {
                        BlocProvider.of<PurchaseCubit>(context)
                            .updateSupplier(null);
                      }
                      return matches;
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return CustomTextField(
                      labelText: "Supplier",
                      focusNode: focusNode,
                      controller: textEditingController,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                      snapshot: snapshot,
                    );
                  },
                  onSelected: (String supplierName) {
                    Supplier supplier = state.suppliers.firstWhere(
                        (element) => element.supplierName == supplierName);
                    BlocProvider.of<PurchaseCubit>(context)
                        .updateSupplier(supplier);
                  },
                );
              }
              return const SizedBox(width: 100, child: Text("Error"));
            },
          );
        });
    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<PurchaseCubit>(context).errorStream,
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

    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        if (state is PurchaseAdded) {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              locator<NavigationService>().navigateTo(PurchaseFormRoute);
              BlocProvider.of<PurchaseCubit>(context).reset();
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
                        supplierFinderField,
                        purchaseNo,
                        const SizedBox(width: 200),
                        const SizedBox(width: 200),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        batchCode,
                        purchaseDate,
                        const SizedBox(width: 200),
                        const SizedBox(width: 200),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [],
                    ),
                  ],
                ),
                StreamBuilder<List<PurchaseItem>>(
                    stream: BlocProvider.of<PurchaseCubit>(context)
                        .purchaseItemsStream,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: 900,
                        child: Column(
                          children: [
                            PurchaseItemTable(
                              purchaseItems:
                                  BlocProvider.of<PurchaseCubit>(context)
                                      .getPurchaseItems(),
                              deletePurchaseItem: _deleteItem,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StreamBuilder<Supplier>(
                                    stream:
                                        BlocProvider.of<PurchaseCubit>(context)
                                            .supplierStream,
                                    builder: (context, snapshot) {
                                      bool enabled = snapshot.hasData;

                                      return GestureDetector(
                                        child: Icon(
                                          Icons.add_box_outlined,
                                          color: enabled
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 25,
                                        ),
                                        onTap: () {
                                          enabled
                                              ? showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (_) {
                                                    return MultiBlocProvider(
                                                      providers: [
                                                        BlocProvider.value(
                                                            value: context.read<
                                                                ProductsCubit>()),
                                                        BlocProvider.value(
                                                            value: context.read<
                                                                PurchaseCubit>()),
                                                      ],
                                                      child:
                                                          AddPurchaseItemDialog(
                                                              addPurchaseItem:
                                                                  _addItem),
                                                    );
                                                  })
                                              : null;
                                        },
                                      );
                                    }),
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
                                        stream: BlocProvider.of<PurchaseCubit>(
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
                        stream: BlocProvider.of<PurchaseCubit>(context)
                            .saveButtonValid,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: snapshot.hasData &&
                                    BlocProvider.of<PurchaseCubit>(context)
                                        .getPurchaseItems()
                                        .isNotEmpty
                                ? () {
                                    BlocProvider.of<PurchaseCubit>(context)
                                        .addPurchase();
                                  }
                                : null,
                            child: const Text("Save"),
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
}
