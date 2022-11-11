import 'package:edar_app/constants/text_field_formats.dart';
import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/pages/purchases/datagrid/purchase_item_datagrid.dart';
import 'package:edar_app/presentation/pages/purchases/purchase_dialog.dart';

import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
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

    var remarks = Column(
      children: [
        CustomTextField(
          labelText: "Remarks",
          onChanged: (remarks) {
            BlocProvider.of<PurchaseCubit>(context).updateRemarks(remarks);
          },
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

    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        if (state is PurchaseAdded) {
          Future.delayed(Duration.zero, () {
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
                      children: [
                        remarks,
                      ],
                    ),
                  ],
                ),
                StreamBuilder<List<PurchaseItem>>(
                    stream: BlocProvider.of<PurchaseCubit>(context)
                        .purchaseItemsStream,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: 1000,
                        height: 350,
                        child: Column(
                          children: [
                            PurchaseItemDataGrid(
                              purchaseItems:
                                  BlocProvider.of<PurchaseCubit>(context)
                                      .getPurchaseItems(),
                              summaryTotal:
                                  BlocProvider.of<PurchaseCubit>(context)
                                      .getTotal(), //TO Update
                              editable: true,
                              addPurchaseItem: _addItem,
                              deletePurchaseItem: _deleteItem,
                            ),
                          ],
                        ),
                      );
                    }),
                Row(
                  children: [
                    StreamBuilder<bool>(
                        stream: BlocProvider.of<PurchaseCubit>(context)
                            .saveButtonValid,
                        builder: (context, snapshot) {
                          return SizedBox(
                            height: 50,
                            width: 150,
                            child: CustomElevatedButton(
                              onPressed: snapshot.hasData
                                  ? () {
                                      _openPurchaseDialog();
                                    }
                                  : null,
                              child: const Text("REVIEW"),
                            ),
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

  void _openPurchaseDialog() {
    Purchase purchase =
        BlocProvider.of<PurchaseCubit>(context).getPurchase(null);
    BlocProvider.of<PurchaseCubit>(context).clearError();
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<PurchaseCubit>(),
            child: PurchaseDialog(
              purchase: purchase,
              flgAddPurchase: true,
            ),
          );
        });
  }
}
